import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'main.dart';

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
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    value: 'system_apps',
                    child: const Text('Toggle system apps')),
                PopupMenuItem<String>(
                  value: 'launchable_apps',
                  child: const Text('Toggle launchable apps only'),
                )
              ];
            },
            onSelected: (key) {
              if (key == 'system_apps') {
                setState(() {
                  _showSystemApps = !_showSystemApps;
                });
              }
              if (key == 'launchable_apps') {
                setState(() {
                  _onlyLaunchableApps = !_onlyLaunchableApps;
                });
              }
            },
          )
        ],
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
            // Remove THIS app from list. For some reason the code below doesn't remove socialshopper.
            apps.removeAt(0);
            for (int i = 0; i < apps.length; i++) {
              if(!apps[i].appName.toString().contains('Venmo')){
                if (!apps[i].appName.toString().contains('Cash App')){
                    apps.removeAt(i);
                }
              }
            }
            print(apps);
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
          }
        });
  }
}
