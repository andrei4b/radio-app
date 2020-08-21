import 'dart:convert';

class Song {
  final String title;
  final String artist;

  Song({this.title, this.artist});

  factory Song.fromJson(dynamic json) {
    String artist, title;
    String artistAndTitle = json['title'] as String;
    if (artistAndTitle.contains(' - ')) {
      List<String> artistAndTitleList = artistAndTitle.split(' - ');
      artist = artistAndTitleList[0];
      title = artistAndTitleList[1];
    }
    else {
      artist = '';
      title = artistAndTitle;
    }
    return Song(
        title: title,
        artist: artist
    );
  }

  @override
  String toString() {
    return '{ ${this.title}, ${this.artist}, }';
  }
}