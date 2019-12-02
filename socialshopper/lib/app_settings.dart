import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;
import 'main.dart';
import 'theme.dart';

class Settings extends StatefulWidget {
  static String tag = 'settings-page';

  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  bool _darkTheme = true;

  //Creates an alert to the user saying that these buttons aren't implemented.
  Future<void> createAlert(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Not Implemented'),
            content: const Text('Coming Soon!'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
      //Top bar of the app
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: globals.mainColor,
        title: const Text('App Settings'),
        automaticallyImplyLeading: false,
      ),

      //All of the important app settings
      body: Center(
          child: ListView(children: <Widget>[
        //Display Settings
        ListTile(
          title: Text('Display',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 20,
              )),
          subtitle: const Text('Enable the settings to change the display.'),
        ),
        SwitchListTile(
          value: _darkTheme,
          title: const Text('Dark Mode'),
          onChanged: (val) {
            setState(() {
              _darkTheme = val;
            });
            onThemeChanged(val, themeNotifier);
          },
        ),

        //Notifications to the user
        ListTile(
          title: Text('Notifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 20,
              )),
          subtitle: Text('Enable the settings to recieve notifications.'),
        ),
        SwitchListTile(
          value: false,
          title: const Text('Push Notifications enabled:'),
          onChanged: (value) {
            createAlert(context);
          },
        ),
        SwitchListTile(
          value: false,
          title: const Text('Email Notifications enabled:'),
          onChanged: (value) {
            createAlert(context);
          },
        ),
        SwitchListTile(
          value: false,
          title: const Text('Reminder to go shopping:'),
          onChanged: (value) {
            createAlert(context);
          },
        ),

        //
        ListTile(
          title: Text('Permissions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 20,
              )),
          subtitle: const Text(
              'Enable the settings to allow this app to access information on your device.'),
        ),
        SwitchListTile(
          value: false,
          title: const Text('Allow access to the Downloads Folder:'),
          onChanged: (value) {
            createAlert(context);
          },
        ),
        SwitchListTile(
          value: false,
          title: const Text('Allow access to Venmo:'),
          onChanged: (value) {
            createAlert(context);
          },
        ),
        SwitchListTile(
          value: false,
          title: const Text('Allow access to Facebook:'),
          onChanged: (value) {
            createAlert(context);
          },
        ),
        SwitchListTile(
          value: true,
          title: const Text('Give devs your first born child:'),
          onChanged: (value) {
            createAlert(context);
          },
        ),
      ])),
    );
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark', value);
  }
}
