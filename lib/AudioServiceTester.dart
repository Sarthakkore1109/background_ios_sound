import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'AudioServiceCustom.dart';
AudioSession audioSession;
class AudioTesting extends StatefulWidget {
  @override
  _AudioTestingState createState() => _AudioTestingState();
}

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class _AudioTestingState extends State<AudioTesting> {

  String a = "50";
  String b = "60";
  String c = "70";
  String d = "80";
  AudioCache _audioCache = AudioCache();
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioCache _audioCache1 = AudioCache();
  AudioPlayer _audioPlayer1 = AudioPlayer();
  AudioCache _audioCache2 = AudioCache();
  AudioPlayer _audioPlayer2 = AudioPlayer();
  AudioCache _audioCache3 = AudioCache();
  AudioPlayer _audioPlayer3 = AudioPlayer();
  AudioCache _audioCache4 = AudioCache();
  AudioPlayer _audioPlayer4 = AudioPlayer();
  AudioCache _audioCache5 = AudioCache();
  AudioPlayer _audioPlayer5 = AudioPlayer();


  @override
  void initState() {
    super.initState();
    /*AudioSession.instance.then((audioSession) async {
      await audioSession.configure(AudioSessionConfiguration.speech());
    });*/
    initSound();
    loadAllFiles();
  }


  @override
  void dispose() async{
    stop();
    //await AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(onPressed: () {
              playID(a);
            },
              child: Text('start'),
            ),
            RaisedButton(onPressed: (){playID(b);},
              child: Text('start'),
            ),
            RaisedButton(onPressed: () {
              playID(c);
            },
              child: Text('start'),
            ),
            RaisedButton(onPressed: () {
              playID(d);
            },
              child: Text('start'),
            ),
            RaisedButton(onPressed: () {
             playID2("80", "SpecialLocation_3");
            },
              child: Text('both'),
            ),
            RaisedButton(onPressed: () {
             playID2("50", null);
            },
              child: Text('one'),
            ),
            RaisedButton(onPressed: () {
             playID2(null, "SpecialLocation_1");
            },
              child: Text('two'),
            ),
            RaisedButton(onPressed: play,
              child: Text('start'),
            ),
            RaisedButton(onPressed: play,
              child: Text('stop'),
            ),
            RaisedButton(onPressed: (){
              Future.delayed(Duration(seconds: 10),(){
                  _audioCache.play('60.mp3');
              });
            },
              child: Text('Loaded all and playing method'),
            ),
            ElevatedButton(onPressed: ()async{
              if (await audioSession.setActive(true)) {
                _audioCache.play('60.mp3');
              } else {
                // The request was denied and the app should not play audio
              }
              }, child: Text('ducking audio')),
          ],
        ),
      ),
    );
  }


  loadAllFiles(){
    _audioCache.load('50.mp3');
    _audioCache1.load('60.mp3');
    _audioCache2.load('70.mp3');
    _audioCache3.load('80.mp3');
    _audioCache4.load('SpecialLocation_1.mp3');
    _audioCache5.load('SpecialLocation_3.mp3');
  }

}

playID2(String speedLimit,String specialLocation){
  MediaItem mediaItem = MediaItem(id: speedLimit, album: null, title: specialLocation);
  AudioService.playMediaItem(mediaItem);
}


playID(String id){
  AudioService.playFromMediaId(id);
}

play() async{
  if (await AudioService.running) {
    sleep(Duration(seconds: 5));
    AudioService.play();
    print('a');
  } else {
    AudioService.start(backgroundTaskEntrypoint: _backgroundTaskEntrypoint);
    print('b');
  }

  //AudioPlayerTask().onPlay();
}

initSound()async{
  await AudioService.connect();
  start();
  //await AudioService.start(backgroundTaskEntrypoint: _backgroundTaskEntrypoint);
  audioSession = await AudioSession.instance;
  await audioSession.configure(AudioSessionConfiguration.speech());
}

start() async => await AudioService.start(backgroundTaskEntrypoint: _backgroundTaskEntrypoint).then((value) => print(value));

stop() => AudioService.stop();

