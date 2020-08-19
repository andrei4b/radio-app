import 'dart:convert';
import 'dart:async';
import 'package:html_unescape/html_unescape_small.dart';

import 'package:http/http.dart' as http;

import 'package:radio_app/models/Song.dart';

Future<List<Song>> fetchSongs() async {
  final response =
      await http.get('https://c28.radioboss.fm/w/recenttrackslist?u=175');
  if (response.statusCode == 200) {
    var unescape = new HtmlUnescape();
    var r = unescape.convert(response.body);
    var jsonResponse = jsonDecode(r) as List;
    //print(jsonResponse);
    List<Song> songsList =
        jsonResponse.map((item) => Song.fromJson(item)).toList();
    List<Song> last6 = songsList.sublist(0, 6);
    //last6.forEach((song) => print(song));
    return last6;
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