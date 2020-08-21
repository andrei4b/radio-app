import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_app/play_stop_streamer.dart';

class ShowDetails extends StatefulWidget {
  final show;

  ShowDetails({Key key, @required this.show}) : super(key: key);

  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  bool isPlaying = false;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  void initPlayer() async {
    await player.setUrl(widget.show['showPromoUrl']);
  }

  void disposePlayer() async {
    await player.dispose();
  }

  @override
  void dispose() {
    disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Emisiuni')),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: widget.show['showPhoto']['url'],
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: widget.show['showPhoto']['url'],
                  placeholder: (context, url) => Container(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
//            SizedBox(
//              height: 10,
//            ),
              Container(
                color: Colors.teal[700],
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            //'Un titluuuu LUUUng Foarte Foarte Luuung',
                            widget.show['showName'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.show['showProducer'] == null
                                ? ' '
                                : '(' + (widget.show['showProducer'] ?? ' ') + ')',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.red[900],
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Difuzare:',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        Text(
                          widget.show['showSchedule'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              widget.show['showRerun'] != null ?
              Container(
                color: Colors.red[900],
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Reluare:',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        Text(
                          widget.show['showRerun'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ) : SizedBox(height: 0),
              SizedBox(
                height: 10,
              ),
              widget.show['showPromoUrl'] != null ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Align(
                  alignment: Alignment.center,
                  child: isPlaying == false ?
                  RaisedButton(
                    color: Colors.red[900],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Promo: ', style: TextStyle(color: Colors.white),),
                        Icon(Icons.play_arrow, color: Colors.white),
                      ],
                    ),
                    onPressed: () async {
                      setState(() {
                        isPlaying = true;
                      });
                      await player.setUrl(widget.show['showPromoUrl']);
//                      PlayStopStreamer().stop();
                      player.play();
                    },
                  ) :
                  RaisedButton(
                    color: Colors.red[900],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Promo: ', style: TextStyle(color: Colors.white),),
                        Icon(Icons.stop, color: Colors.white),
                      ],
                    ),
                    onPressed: () async {
                      setState(() {
                        isPlaying = false;
                      });
                      player.stop();
                    },
                  )
                ),
              ) : SizedBox(height: 0,),
//              SizedBox(
//                height: 10,
//              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Text(widget.show['showDescription']),
              )
            ],
          ),
        ));
  }
}
