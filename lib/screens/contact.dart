import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  String livePhone = '0369807078';
  String smsPhone = '0742805746';
  String email = 'radiovesteabuna@gmail.com';
  String website = 'radiovesteabuna.ro';
  String facebook = 'facebook.com/radiovesteabuna';
  String fbProtocolUrl = 'fb://page/504433063012609';
  String fallbackUrl = 'https://www.facebook.com/radiovesteabuna';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contact'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage('assets/images/green_large_logo.png'),
                  height: 275,
                  alignment: Alignment.center,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.phone),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                              child: Text(
                                '0369 807 078',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.teal),
                              ),
                              onTap: () {
                                launch('tel:$livePhone');
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.phone_android),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                              child: Text(
                                '0742 805 746',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.teal),
                              ),
                              onTap: () {
                                launch('tel:$smsPhone');
                              }),
                          Text(' (SMS/WhatsApp)')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.email),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: InkWell(
                              child: Text(
                                'radiovesteabuna@gmail.com',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.teal),
                              ),
                              onTap: () {
                                launch('mailto:$email');
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.language),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: InkWell(
                              child: Text(
                                'radiovesteabuna.ro',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.teal),
                              ),
                              onTap: () =>
                                  launch('https://radiovesteabuna.ro/'),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/facebook_logo.png',
                            height: 23,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: InkWell(
                                child: Text(
                                  'facebook.com/radiovesteabuna',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.teal),
                                ),
                                onTap: () async {
                                  try {
                                    bool launched = await launch(fbProtocolUrl,
                                        forceSafariVC: false);
                                    if (!launched) {
                                      await launch(fallbackUrl,
                                          forceSafariVC: false);
                                    }
                                  } catch (e) {
                                    await launch(fallbackUrl,
                                        forceSafariVC: false);
                                  }
                                }),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
