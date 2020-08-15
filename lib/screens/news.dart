import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final dbRef = FirebaseDatabase.instance.reference().child("news");
  List<dynamic> news = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noutăți'),
      ),
      body: FutureBuilder(
        future: dbRef.once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            news.clear();
            //print(snapshot.data.value);
            List<dynamic> values = snapshot.data.value;
            values.forEach((e) {
              if(e != null)
                news.add(e);
            });
            news.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
            //print(news);
            return ListView.builder(
              shrinkWrap: true,
              itemCount: news.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      launch(news[index]['newsURL']);
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: news[index]['newsThumbnail']['url'],
                            height: 235,
                            placeholder: (context, url) => Container(
                              child: Center(child: CircularProgressIndicator()),
                              height: 235,
                            ),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        news[index]['newsName'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
