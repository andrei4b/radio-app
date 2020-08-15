import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var notifications = true;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  SharedPreferences prefs;

  void saveNotificationsSettings() async {
    prefs = await SharedPreferences.getInstance();
    if(notifications) {
      firebaseMessaging.subscribeToTopic('general');
      print('Turned On');
    } else {
      firebaseMessaging.unsubscribeFromTopic('general');
      print('Turned Off');
    }
    prefs.setBool('notifications', notifications);
  }

  void getNotificationsSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications = prefs.getBool('notifications');
    });
  }

  @override
  void initState() {
    super.initState();
    getNotificationsSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setări'),
      ),
      body: SwitchListTile(
        value: notifications,
        title: Text("Primește notificări"),
        onChanged: (value) {
          setState(() {
            notifications = value;
          });
          saveNotificationsSettings();
        },
      ),
    );
  }
}
