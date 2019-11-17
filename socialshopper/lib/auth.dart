//This .dart file handles all of the sign ins to Google and Firebase, the latter so that user's data can be stored.
//This data can then be used to attach the shopping lists to the users, such as the UID.
//This file also handles sign outs for both Firebase and Google Accounts.

//Necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
//The following is a real time dart package. Documentation here: https://pub.dev/packages/rxdart
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  //Initialize Observable objects
  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  //Status for listeners. Is it in process of signing in or not?
  PublishSubject loading = PublishSubject<dynamic>();

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);
    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.empty();
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    //Get credentials from googleAuth
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    //Use credentials from before to login to Firebase
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    //Make sure fields entered/returned are not null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    updateUserData(user);
    print('Signed in ' + user.displayName);

    loading.add(false);
    return user;
  }

  //Store user's data
  List<String> friends = [];
  List<String> lists = [];
  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    //Map data to database fields
    if (ref.collection('users/friends') == null && ref.collection('users/lists') == null)
      return ref.setData({
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoUrl,
        'displayName': user.displayName,
        'lastSeen': DateTime.now(),
        'friends' : friends,
        'lists' : lists,
      }, merge: true); //Merges data so old data isn't overwritten
    else
      return ref.setData({
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoUrl,
        'displayName': user.displayName,
        'lastSeen': DateTime.now(),
      }, merge: true); //Merges data so old data isn't overwritten
  }

  void signOut() async {
    //Wait for Firebase signout
    await _auth.signOut();
    //Wait for Google Sign out
    await _googleSignIn.signOut();
  }
}

final AuthService authService = AuthService();
