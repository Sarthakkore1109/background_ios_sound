import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioCache _audioCache = AudioCache();
  Completer _completer = Completer();


  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    _audioCache.load('80.mp3');
    //_audioPlayer = await _audioCache.play('80.mp3');
  }

  @override
  Future<void> onPlayFromMediaId(String mediaId) async {
    _audioCache.load('$mediaId.mp3');
    _audioPlayer = await _audioCache.play('$mediaId.mp3');
    return super.onPlayFromMediaId(mediaId);
  }

  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async{
    String speedLimit = mediaItem.id;
    String special = mediaItem.title;

    Future.delayed(Duration(seconds: 5),()async{
      if(special == null){
        _audioCache.load('$speedLimit.mp3');
        _audioPlayer = await _audioCache.play('$speedLimit.mp3');
        print('special null');
      }
      else{
        print('special null not');
        _audioCache.load('$special.mp3');
        _audioPlayer = await _audioCache.play('$special.mp3');
        _audioPlayer.onPlayerCompletion.listen((event) async {
          print('special null not 2');
          _audioCache.load('$speedLimit.mp3');
          _audioPlayer = await _audioCache.play('$speedLimit.mp3');
        });
      }
    });






    return super.onPlayMediaItem(mediaItem);
  }

  @override
  Future<void> onPlay()async {
    _audioCache.load('80.mp3');
    _audioPlayer = await _audioCache.play('80.mp3');
    return super.onPlay();
  }

  @override
  Future<void> onStop() async {
    // Stop playing audio
    await _audioPlayer.stop();
    // Shut down this background task
    await super.onStop();
  }
}
