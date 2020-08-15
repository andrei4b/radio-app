import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';

class Members extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  SharedPreferences prefs;
  final dbRef = FirebaseDatabase.instance.reference().child("member");
  List<dynamic> members = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Despre noi'),
        ),
        body: FutureBuilder(
          future: dbRef.once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData) {
              members.clear();
              //print(snapshot.data.value);
              List<dynamic> values = snapshot.data.value;
              values.forEach((e) {
                if(e != null)
                  members.add(e);
              });
              return ListView.builder(
                shrinkWrap: true,
                itemCount: members.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: FlipCard(
                      //margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      front: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: const Offset(0.0, 3.0),
                            blurRadius: 3.0,
                            spreadRadius: 0.1,
                          ),
                        ]),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            Positioned(
                              child: Container(
                                child: CachedNetworkImage(
                                  height: 320,
                                  fit: BoxFit.fill,
                                  imageUrl: members[index]['memberPhoto']
                                      ['url'],
                                  placeholder: (context, url) => Container(
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                    height: 320,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              ),
                            ),
                            Positioned(
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        members[index]['memberName'],
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
                            ),
                          ],
                        ),
                      ),
                      back:
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: const Offset(0.0, 3.0),
                                  blurRadius: 3.0,
                                  spreadRadius: 0.1,
                                ),
                              ],
                              color: Colors.teal,
                              //borderRadius: BorderRadius.circular(3),
                            ),
                            padding: EdgeInsets.all(24),
                            height: 320,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Icon(Icons.arrow_back, color: Colors.white),
                                ),
                                Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.symmetric(vertical: 2.0),
                                          child: Text(
                                            members[index]['memberName'],
                                            style: TextStyle(
                                                fontSize: members[index]['memberDescription'].length > 250 ? 15 : 16 ,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Text(
                                            '(' +
                                                members[index]['memberPosition'] +
                                                ')',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white, fontSize: members[index]['memberDescription'].length > 250 ? 13 : 14 ,),
                                          ),
                                        ),
                                        Text(
                                          members[index]['memberDescription'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: members[index]['memberDescription'].length > 250 ? 11 : 12 ,),
                                        ),
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
        ));
  }
}
