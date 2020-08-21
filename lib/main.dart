import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:radio_app/current_songs.dart';
import 'package:radio_app/screens/favorites.dart';
import 'screens/members.dart';
import 'package:radio_app/widgets/messaging_widget.dart';
import 'widgets/nav_drawer.dart';
import 'models/Song.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'play_stop_streamer.dart';
import 'screens/settings.dart';
import 'screens/contact.dart';
import 'screens/info.dart';
import 'screens/shows.dart';
import 'screens/news.dart';
import 'screens/archive.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:like_button/like_button.dart';
import 'package:intl/intl.dart';
import 'dart:isolate';

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/audio_service_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/audio_service_stop',
  label: 'Stop',
  action: MediaAction.pause,
);
MediaControl closeControl = MediaControl(
  androidIcon: 'drawable/ic_close',
  label: 'Close',
  action: MediaAction.stop,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(RadioPlayer());
  });
}

class RadioPlayer extends StatefulWidget {
  @override
  _MyRadioPlayer createState() => _MyRadioPlayer();
}

class _MyRadioPlayer extends State<RadioPlayer> with WidgetsBindingObserver {
  bool isPlaying = false;
  String currentSongTitle = '';
  String currentSongArtist = '';
  bool notificationsOn = false;
  var currentSongsSubscription;
  var playStopSubscription;
  var customEventSubscription;
  FavoritesManager favoritesManager = FavoritesManager();
  bool liked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkNotificationsSubscription();
    connect();

    customEventSubscription = AudioService.playbackStateStream.listen((value) {
      var playing = value?.playing ?? false;
      var processingState = value?.processingState ?? AudioProcessingState.none;
      //print(processingState);
      //print(playing);

      if (!playing) {
        if (processingState == AudioProcessingState.ready ||
            processingState == AudioProcessingState.none)
          setState(() {
            isPlaying = false;
          });
      } else if (playing) {
        setState(() {
          isPlaying = true;
        });
      } else {}
    });

    currentSongsSubscription =
        CurrentSongsFetcher().stream.listen((songs) async {
      liked = await favoritesManager
          .isFavorite('${songs[0].title} - ${songs[0].artist}');
      setState(() {
        currentSongTitle = songs[0].title;
        currentSongArtist = songs[0].artist;
      });
    });
  }

  @override
  void dispose() {
    disconnect();
    WidgetsBinding.instance.removeObserver(this);
    currentSongsSubscription.cancel();
    customEventSubscription.cancel();
    super.dispose();
  }

  void checkNotificationsSubscription() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('notifications') == null) {
      firebaseMessaging.subscribeToTopic('general');
      prefs.setBool('notifications', true);
    }
  }

  void connect() async {
    await AudioService.connect();
  }

  void disconnect() {
    AudioService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Radio Vestea Bună',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: ThemeData(
          //brightness: Brightness.dark,
          primaryColor: Colors.teal,
          accentColor: Colors.tealAccent,
          fontFamily: 'Open Sans',

//          textTheme: TextTheme(
//            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//          ),
        ),
        routes: {
          '/favorites': (context) => Favorites(),
          '/members': (context) => Members(),
          '/settings': (context) => Settings(),
          '/contact': (context) => Contact(),
          '/info': (context) => Info(),
          '/shows': (context) => Shows(),
          '/news': (context) => News(),
          '/archive': (context) => Archive()
        },
        home: WillPopScope(
          onWillPop: () {
            disconnect();
            return Future.value(true);
          },
          child: AudioServiceWidget(
            child: Scaffold(
              backgroundColor: Colors.white,
              drawer: NavDrawer(),
              appBar: AppBar(
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.menu, color: Colors.teal),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: const Text(''),
                centerTitle: true,
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    flex: 25,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: StreamBuilder<List<Song>>(
                          stream: CurrentSongsFetcher().stream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error');
                            }
                            var songs = snapshot.data;
                            return Stack(
                              children: <Widget>[
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          songs[0].title,
                                          //'foarte foarte foarte luuuuuuuung zici?',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          songs[0].artist,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Builder(
                                    builder: (context) => LikeButton(
                                        padding: EdgeInsets.only(
                                            bottom: 20,
                                            top: 20,
                                            right: 15,
                                            left: 20),
                                        size: 25,
                                        isLiked: liked,
                                        onTap: (isLiked) async {
                                          Scaffold.of(context)
                                              .removeCurrentSnackBar();
                                          String entry =
                                              '$currentSongTitle - $currentSongArtist';
                                          if (!isLiked) {
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Melodia a fost adăugată la favorite!"),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                            await favoritesManager
                                                .saveFavorite(entry);

                                            setState(() {
                                              liked = !isLiked;
                                            });

                                            return !isLiked;
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Melodia a fost eliminată de la favorite!"),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                            await favoritesManager
                                                .removeFavorite(entry);
                                            setState(() {
                                              liked = !isLiked;
                                            });
                                            return !isLiked;
                                          }
                                        }),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Container(
                      //color: Colors.grey[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: (isPlaying == true)
                                ? MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        isPlaying = false;
                                      });
                                      AudioService.pause();
                                    },
                                    color: Colors.teal,
                                    child: Icon(Icons.stop,
                                        size: 38, color: Colors.white),
                                    padding: EdgeInsets.all(16),
                                    shape: CircleBorder(),
                                  )
                                : MaterialButton(
                                    onPressed: () async {
                                      setState(() {
                                        isPlaying = true;
                                      });
                                      await AudioService.start(
                                        backgroundTaskEntrypoint:
                                            _audioPlayerTaskEntrypoint,
                                        androidNotificationChannelName:
                                            'Radio Vestea Bună',
                                        androidNotificationColor: 0xFF09B89B,
                                        androidNotificationIcon:
                                            'mipmap/ic_launcher',
                                      );
                                      AudioService.play();
                                    },
                                    color: Colors.teal,
                                    child: Icon(Icons.play_arrow,
                                        size: 38, color: Colors.white),
                                    padding: EdgeInsets.all(16),
                                    shape: CircleBorder(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 50,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0)),
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: StreamBuilder<List<Song>>(
                          stream: CurrentSongsFetcher().stream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error');
                            }
                            var songs = snapshot.data;
                            return ListView(
                              children: List.generate(5, (index) {
//                                var date =
//                                    new DateTime.fromMillisecondsSinceEpoch(
//                                        songs[index + 1].playedAt * 1000);
//                                var time = DateFormat.Hm().format(date);
                                return Container(
                                  margin: EdgeInsets.only(bottom: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: Colors.teal[50],
                                  ),
                                  child: ListTile(
//                                    trailing: Text(
//                                      '$time',
//                                      style: TextStyle(
//                                          fontSize: 12,
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.bold),
//                                    ),
                                    title: Text(
                                      '${songs[index + 1].title}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '${songs[index + 1].artist}',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.black),
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),
                    ),
                  ),
                  MessagingWidget(),
                ],
              ),
            ),
          ),
        ));
  }
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask {
  static const String URL = "http://198.50.156.36:8246/stream";
  static const String NEW_URL = "https://c28.radioboss.fm:18175/stream";
  static const String NEW_URL2 = "http://c28.radioboss.fm:8175/stream";

  AudioPlayer _audioPlayer = AudioPlayer();
  AudioProcessingState _audioProcessingState;
  bool _playing = false;
  bool _interrupted = false;

  StreamSubscription<PlaybackEvent> eventSubscription;
  var currentSongsSubscription;

  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(controls: [
      if (_audioPlayer.playing) stopControl else playControl,
      closeControl,
    ], processingState: _getProcessingState(), playing: _playing);
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_audioProcessingState] instead.
  AudioProcessingState _getProcessingState() {
    if (_audioProcessingState != null) return _audioProcessingState;
    switch (_audioPlayer.processingState) {
      case ProcessingState.none:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_audioPlayer.processingState}");
    }
  }

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      _broadcastState();
    });

    _audioPlayer.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.completed:
          onStop();
          break;
        case ProcessingState.ready:
          break;
        default:
          break;
      }
    });
    currentSongsSubscription = CurrentSongsFetcher().stream.listen((songs) {
      var mediaItem = MediaItem(
        id: songs[0].title ?? '',
        title: songs[0].title ?? '',
        artist: songs[0].artist ?? '',
        album: '',
      );
      try {
        AudioServiceBackground.setMediaItem(mediaItem);
      } catch (e) {
        print('exception');
      }
    });

    try {
      onPlay();
    } catch (e) {
      print(e);
      onStop();
    }
  }

  @override
  Future<void> onStop() async {
    _playing = false;
    await _audioPlayer.pause();
    await _audioPlayer.dispose();
    eventSubscription.cancel();

    await _broadcastState();
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    try {
      await _audioPlayer.setUrl(NEW_URL2);
    } catch (e) {
      print(e);
    }
    AudioServiceBackground.setState(
      controls: [stopControl, closeControl],
      processingState: AudioProcessingState.ready,
      playing: true,
    );
    _playing = true;
    return _audioPlayer.play();
  }

  Future<void> playPause() async {
    if (AudioServiceBackground.state.playing)
      onPause();
    else
      onPlay();
  }

  @override
  Future<void> onPause() {
    _playing = false;
    return _audioPlayer.pause();
  }

  @override
  Future<void> onClick(MediaButton button) => playPause();

  @override
  Future<void> onTaskRemoved() async {
    await onStop();
    super.onTaskRemoved();
  }

  @override
  Future<void> onAudioFocusLost(AudioInterruption interruption) async {
    if (_audioPlayer.playing) _interrupted = true;
    // If another app wants to take over the audio focus, we either pause (e.g.
    // during a phonecall) or duck (e.g. if Maps Navigator starts speaking).
    if (interruption == AudioInterruption.temporaryDuck) {
      _audioPlayer.setVolume(0.5);
    } else {
      onPause();
    }
  }

  @override
  Future<void> onAudioFocusGained(AudioInterruption interruption) async {
    switch (interruption) {
      case AudioInterruption.temporaryPause:
        // Resume playback again. But only if we *were* originally playing at
        // the time the phone call came through. If we were paused when the
        // phone call came, we shouldn't suddenly start playing when they hang
        // up.
        if (!_audioPlayer.playing && _interrupted) onPlay();
        break;
      case AudioInterruption.temporaryDuck:
        // Resume normal volume after a duck.
        _audioPlayer.setVolume(1.0);
        break;
      default:
        break;
    }
    _interrupted = false;
  }
}
