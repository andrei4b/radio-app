import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> _handleNotificationClick(Map<String, dynamic> message) async {
    var data = message['data'] ?? message;
    //print(data);
    String notificationUrl = data['notificationUrl'] ?? null;
    if(notificationUrl != null)
      launch(notificationUrl);
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    var data = message['data'] ?? message;
                    //print(data);
                    String notificationUrl = data['notificationUrl'] ?? null;
                    if(notificationUrl != null) {
                      Navigator.of(context).pop();
                      launch(notificationUrl);
                    }
                    else
                      Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
          print('onMessage: $message');
        },
        onLaunch: _handleNotificationClick,
        onResume: _handleNotificationClick);
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0,
      height: 0,
    );
  }
}
