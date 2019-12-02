// This file creates a page in which the user can select which app they want to use to pay. The app could either be Cash App
// or Venmo. This is done by getting the apps installed on the phone and displaying Venmo and/or Cash App if they are available.
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'globals.dart' as globals;

class Payment extends StatefulWidget {
  static String tag = 'payment';

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool _showSystemApps = false;
  bool _onlyLaunchableApps = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
        backgroundColor: globals.mainColor,
      ),
      body: _PaymentContent(
          includeSystemApps: _showSystemApps,
          onlyAppsWithLaunchIntent: _onlyLaunchableApps,
          key: GlobalKey()),
    );
  }
}

class _PaymentContent extends StatelessWidget {
  final bool includeSystemApps;
  final bool onlyAppsWithLaunchIntent;

  const _PaymentContent(
      {Key key,
      this.includeSystemApps = false,
      this.onlyAppsWithLaunchIntent = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DeviceApps.getInstalledApplications(
            includeAppIcons: true,
            includeSystemApps: includeSystemApps,
            onlyAppsWithLaunchIntent: onlyAppsWithLaunchIntent),
        builder: (context, data) {
          if (data.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Application> apps = data.data;
            // Remove app from list if not a payment app.
            for (int i = 0; i < apps.length; i++) {
              if (apps[i] != null) {
                if (!apps[i].appName.toString().contains('Venmo')) {
                  if (!apps[i].appName.toString().contains('Cash App')) {
                    apps.remove(apps[i]);
                    // If you did remove an app, you have to set i = -1 so that 0 is looked at again as things are shifted left.
                    i = -1;
                  }
                }
              }
            }
            if (apps.isNotEmpty) {
              return ListView.builder(
                  itemBuilder: (context, position) {
                    Application app = apps[position];
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: app is ApplicationWithIcon
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(app.icon),
                                  backgroundColor: Colors.white,
                                )
                              : null,
                          onTap: () => DeviceApps.openApp(app.packageName),
                          title: Text('${app.appName}'),
                        ),
                        Divider(
                          height: 1.0,
                        )
                      ],
                    );
                  },
                  itemCount: apps.length);
            } else
              return Center(
                child: const Text(
                  'You don\'t have any payment apps (Venmo or Cash App).',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              );
          }
        });
  }
}
