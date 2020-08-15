import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:radio_app/models/Song.dart';

class LastSongs extends StatefulWidget {
  @override
  _LastSongsState createState() => _LastSongsState();
}

class _LastSongsState extends State<LastSongs> {
  String currentSong = '';
  Future<List<Song>> futureSongs;

  Future<List<Song>> fetchSongs() async {
    final response = await http.get('http://198.50.156.36:8246/played.html?type=json');
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      List<Song> songsList = jsonResponse.map((item) => Song.fromJson(item)).toList();
//      songsList.forEach((song) =>
//          print(song.title)
//      );
      return songsList;
    } else {
      throw Exception('Failes to load Song.');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Song>>(
      future: fetchSongs(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Now playing: ' + snapshot.data[0].title, style: TextStyle(color: Colors.white),),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      }
    );
  }
}
