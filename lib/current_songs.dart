import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

import 'package:radio_app/models/Song.dart';

Future<List<Song>> fetchSongs() async {
  final response =
      await http.get('http://198.50.156.36:8246/played.html?type=json');
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as List;
    List<Song> songsList =
        jsonResponse.map((item) => Song.fromJson(item)).toList();
    songsList.forEach((song) => print(song));
    return songsList;
  } else {
    throw Exception('Failes to load Song.');
  }
}

class CurrentSongsFetcher {
  static final CurrentSongsFetcher _instance = CurrentSongsFetcher._internal();
  factory CurrentSongsFetcher() {
    return _instance;
  }
  Timer timer;
  final _controller = StreamController<List<Song>>.broadcast();

  CurrentSongsFetcher._internal() {
    fetchSongs().then((songs) {
      _controller.sink.add(songs);
    });

    timer = Timer.periodic(Duration(seconds: 10), (Timer timer) async {
      fetchSongs().then((songs) {
        _controller.sink.add(songs);
      });
    });
  }

  void refresh() {
    print('refreshing...');
    fetchSongs().then((songs) {
      _controller.sink.add(songs);
    });
  }

  Stream<List<Song>> get stream => _controller.stream;

  void finish() {
    _controller.close();
  }
}