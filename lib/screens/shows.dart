import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'show_details.dart';

class Shows extends StatefulWidget {
  @override
  _ShowsState createState() => _ShowsState();
}

class _ShowsState extends State<Shows> {
  final dbRef = FirebaseDatabase.instance.reference().child("show");
  List<dynamic> shows = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emisiuni'),
      ),
      body: FutureBuilder(
        future: dbRef.once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            shows.clear();
            //print(snapshot.data.value);
            List<dynamic> values = snapshot.data.value;
            values.forEach((e) {
              if(e != null)
                shows.add(e);
            });
            return ListView.builder(
              shrinkWrap: true,
              itemCount: shows.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowDetails(show: shows[index],)
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Hero(
                            tag: shows[index]['showPhoto']['url'],
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl: shows[index]['showPhoto']['url'],
                              height: 235,
                              placeholder: (context, url) => Container(
                                child: Center(child: CircularProgressIndicator()),
                                height: 235,
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    shows[index]['showName'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 8.0),
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
