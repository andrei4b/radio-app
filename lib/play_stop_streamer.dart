import 'dart:convert';
import 'dart:async';


class PlayStopStreamer {
  static final PlayStopStreamer _instance = PlayStopStreamer._internal();
  factory PlayStopStreamer() {
    return _instance;
  }
  final _controller = StreamController<bool>.broadcast();
  Timer timer;
  bool playing = true;

  PlayStopStreamer._internal();

  Stream<bool> get stream => _controller.stream;

  void play() {
    print('Added true');
    playing = true;
    _controller.sink.add(playing);
  }

  void stop(){
    print('Added false');
    playing = false;
    _controller.sink.add(playing);
  }

  void finish() {
    _controller.close();
  }
}