//This file will handle the push notifications through deploying the function sendFriendNotification on Firebase.
//If Firebase detects a write in the friends portion of the database, then the user being friended will receive a notification.
//This is mostly copied from https://github.com/firebase/functions-samples/blob/master/fcm-notifications/functions/index.js
'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

/**
 * Triggers when a user gets a new friend and sends a notification.
 *
 * friends add a flag to `/friends/{mainUid}/{friendUid}`.
 * Users save their device notification tokens to `/users/{mainUid}/notificationTokens/{notificationToken}`.
 */
//Following is the path to the friends portion in the database.
exports.sendfriendNotification = functions.database.ref('/users/{uid}/friends/{$}/{friendUid}')
//If write detected, then do the following:
    .onWrite(async (change, context) => {
      const friendUid = context.params.friendUid;
      const mainUid = context.params.mainUid;
      // If un-follow we exit the function.
      if (!change.after.val()) {
        return console.log('User ', friendUid, 'un-main user', mainUid);
      }
      console.log('We have a new friend UID:', friendUid, 'for user:', mainUid);

      // Get the list of device notification tokens.
      const getDeviceTokensPromise = admin.database()
          .ref(`/users/${mainUid}/notificationTokens`).once('value');

      // Get the friend profile.
      const getfriendProfilePromise = admin.auth().getUser(friendUid);

      // The snapshot to the user's tokens.
      let tokensSnapshot;

      // The array containing all the user's tokens.
      let tokens;

      const results = await Promise.all([getDeviceTokensPromise, getfriendProfilePromise]);
      tokensSnapshot = results[0];
      const friend = results[1];

      // Check if there are any device tokens.
      if (!tokensSnapshot.hasChildren()) {
        return console.log('There are no notification tokens to send to.');
      }
      console.log('There are', tokensSnapshot.numChildren(), 'tokens to send notifications to.');
      console.log('Fetched friend profile', friend);

      // Notification details.
      const payload = {
        notification: {
          title: 'You have a new friend!',
          body: `${friend.displayName} is now following you.`,
        }
      };

      // Listing all tokens as an array.
      tokens = Object.keys(tokensSnapshot.val());
      // Send notifications to all tokens.
      const response = await admin.messaging().sendToDevice(tokens, payload);
      // For each message check if there was an error.
      const tokensToRemove = [];
      response.results.forEach((result, index) => {
        const error = result.error;
        if (error) {
          console.error('Failure sending notification to', tokens[index], error);
          // Cleanup the tokens who are not registered anymore.
          if (error.code === 'messaging/invalid-registration-token' ||
              error.code === 'messaging/registration-token-not-registered') {
            tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
          }
        }
      });
      return Promise.all(tokensToRemove);
    });