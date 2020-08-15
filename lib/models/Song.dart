class Metadata {
  final String tit2;

  Metadata({this.tit2});

  factory Metadata.fromJson(dynamic json) {
    return Metadata(tit2: json['tit2'] as String);
  }

  @override
  String toString() {
    return '{ ${this.tit2} }';
  }
}

class Song {
  final int playedAt;
  final String title;
  final String artist;
  final Metadata metadata;

  Song({this.playedAt, this.title, this.artist, this.metadata});

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
        playedAt: json['playedat'] as int,
        title: title,
        artist: artist,
        metadata: Metadata.fromJson(json['metadata'])
    );
  }

  @override
  String toString() {
    return '{ ${this.playedAt}, ${this.title}, ${this.artist}, ${this.metadata} }';
  }
}