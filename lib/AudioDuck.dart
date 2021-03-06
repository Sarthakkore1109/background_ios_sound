import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:background_ios_sound/AudioServiceTester.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;


class AudioDucking extends StatefulWidget {
  @override
  _AudioDuckingState createState() => _AudioDuckingState();
}

class _AudioDuckingState extends State<AudioDucking> {
  final _player = ja.AudioPlayer(
    // Handle audio_session events ourselves for the purpose of this demo.
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );

  AudioCache audioCache = AudioCache();
  
  @override
  void initState() {
    super.initState();
    AudioSession.instance.then((audioSession) async {
      // This line configures the app's audio session, indicating to the OS the
      // type of audio we intend to play. Using the "speech" recipe rather than
      // "music" since we are playing a podcast.
      //await audioSession.configure(AudioSessionConfiguration.speech());
      await audioSession.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
      // Listen to audio interruptions and pause or duck as appropriate.
      _handleInterruptions(audioSession);
      // Use another plugin to load audio to play.
      //await _player.setUrl("https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3");
      await _player.setAsset('assets/60.mp3');

      audioCache.load('60.mp3');
    });
  }

  void _handleInterruptions(AudioSession audioSession) {
    // just_audio can handle interruptions for us, but we have disabled that in
    // order to demonstrate manual configuration.
    bool playInterrupted = false;
    audioSession.becomingNoisyEventStream.listen((_) {
      print('PAUSE');
      _player.pause();
    });
    _player.playingStream.listen((playing) {
      playInterrupted = false;
      if (playing) {
        audioSession.setActive(true);
      }
    });
    audioSession.interruptionEventStream.listen((event) {
      print('interruption begin: ${event.begin}');
      print('interruption type: ${event.type}');
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes.usage ==
                AndroidAudioUsage.game) {
              _player.setVolume(_player.volume / 2);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            _player.setVolume(_player.volume / 2);
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            if (_player.playing) {
              //_player.pause();
              _player.setVolume(_player.volume / 2);
              playInterrupted = false;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(min(1.0, _player.volume * 2));
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) _player.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            _player.setVolume(_player.volume / 2);
            playInterrupted = false;
            break;
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('audio_session example'),
        ),
        body: Center(
          child: Column(
            children: [
              /*StreamBuilder<ja.PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  if (playerState?.processingState != ja.ProcessingState.ready) {
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      width: 64.0,
                      height: 64.0,
                      child: CircularProgressIndicator(),
                    );
                  } else if (playerState?.playing == true) {
                    return IconButton(
                      icon: Icon(Icons.pause),
                      iconSize: 64.0,
                      onPressed: _player.pause,
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.play_arrow),
                      iconSize: 64.0,
                      onPressed: _player.play,
                    );
                  }
                },
              ),*/
              ElevatedButton(onPressed: ()async{
                  _player.play();
                },
                  child: Text('hello'))
            ],
          ),
        ),
      ),
    );
  }
}