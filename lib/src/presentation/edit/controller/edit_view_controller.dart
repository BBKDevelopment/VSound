// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:audio_player_service/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_service/photo_manager_service.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vsound/src/components/components.dart';
import 'package:vsound/src/core/core.dart';
import 'package:vsound/src/presentation/presentation.dart';
import 'package:wakelock_service/wakelock_service.dart';

class EditViewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  EditViewController({
    required PhotoManagerService photoManagerService,
    required VideoPlayerService videoPlayerService,
    required AudioPlayerService audioPlayerService,
    required FFmpegKitService ffmpegKitService,
    required WakelockService wakelockService,
  })  : _photoManagerService = photoManagerService,
        _videoPlayerService = videoPlayerService,
        _audioPlayerService = audioPlayerService,
        _ffmpegKitService = ffmpegKitService,
        _wakelockService = wakelockService,
        _autoScrollController = AutoScrollController(),
        _animatedControlButtonController = AnimatedControlButtonController(),
        _audios = <AssetEntity>[].obs,
        _isVideoReady = false.obs,
        _isAudioReady = false.obs,
        _isVideoPlaying = false.obs,
        _isProgressCompleted = false.obs,
        _speedValue = 3.0.obs,
        _qualityValue = 6.0.obs,
        _progressPercentage = 0.0.obs,
        _selectedSoundIndex = (-1).obs,
        _videoFile = null,
        _speedValueText = '1.00',
        _qualityValueText = 'Default',
        _shouldRefreshMedia = false;

  final PhotoManagerService _photoManagerService;
  final VideoPlayerService _videoPlayerService;
  final AudioPlayerService _audioPlayerService;
  final FFmpegKitService _ffmpegKitService;
  final WakelockService _wakelockService;
  final AutoScrollController _autoScrollController;
  final AnimatedControlButtonController _animatedControlButtonController;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  final RxList<AssetEntity> _audios;
  final RxBool _isVideoReady;
  final RxBool _isAudioReady;
  final RxBool _isVideoPlaying;
  final RxBool _isProgressCompleted;
  final RxDouble _speedValue;
  final RxDouble _qualityValue;
  final RxDouble _progressPercentage;
  final RxInt _selectedSoundIndex;
  File? _videoFile;
  String _speedValueText;
  String _qualityValueText;
  bool _shouldRefreshMedia;
  File? _audioFile;

  VideoPlayerService get videoPlayerService => _videoPlayerService;
  AutoScrollController get autoScrollController => _autoScrollController;
  AnimationController get animationController => _animationController;
  AnimatedControlButtonController get animatedControlButtonController =>
      _animatedControlButtonController;
  Animation<double> get animation => _animation;
  List<AssetEntity> get audios => _audios;
  bool get isVideoReady => _isVideoReady.value;
  bool get isVideoPlaying => _isVideoPlaying.value;
  bool get isProgressCompleted => _isProgressCompleted.value;
  bool get shouldRefreshMedia => _shouldRefreshMedia;
  double get speedValue => _speedValue.value;
  double get progressPercentage => _progressPercentage.value;
  double get qualityValue => _qualityValue.value;
  int get selectedSoundIndex => _selectedSoundIndex.value;
  String get speedValueText => _speedValueText;
  String get qualityValueText => _qualityValueText;

  @override
  void onInit() {
    _animationController = AnimationController(
      vsync: this,
      duration: AnimationDuration.editPageIn,
    );
    _animation = Tween(begin: 0.toDouble(), end: 1.toDouble())
        .animate(_animationController);
    super.onInit();
  }

  @override
  void onClose() {
    _videoPlayerService.dispose();
    _audioPlayerService.dispose();
    super.dispose();
  }

  Future<void> getMedia() async {
    try {
      _audios.value = await _photoManagerService.getAudios();
    } on PermissionException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message:
            'Could not access the media! Please be sure that permission to '
            'access media is granted.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    } on GetAudioException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message:
            'Could not get audio assets! Please be sure that permission to '
            'access media is granted.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }

  Future<void> setFile(Future<File?> file) async {
    try {
      _videoFile = await file;
    } catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not set the video file! An error occurred while '
            'loading the video file.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
      _videoFile = null;
    }
  }

  void close() {
    if (_videoFile == null) return;

    _isVideoPlaying.value = false;
    _isVideoReady.value = false;
    _isAudioReady.value = false;
    _selectedSoundIndex.value = -1;
    _audioFile = null;
    _videoPlayerService
      ..removeListener(_videoListener)
      ..dispose();
    _audioPlayerService.dispose();
  }

  Future<void> resetEditPage() async {
    if (_videoFile == null) return;

    try {
      await Future.wait<void>([
        _videoPlayerService.loadFile(_videoFile!),
        _audioPlayerService.stop(),
      ]);
      _videoPlayerService.removeListener(_videoListener);
      _selectedSoundIndex.value = -1;
      _speedValue.value = 3.0;
      _speedValueText = '1.00';
      _isVideoReady.value = true;
    } on LoadVideoException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not load the video! An error occurred while loading '
            'the video.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    } on StopAudioException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not stop the audio! An error occurred while stopping '
            'the audio.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }

  Future<void> _videoListener() async {
    if (_videoPlayerService.position.inSeconds !=
        _videoPlayerService.duration.inSeconds) return;

    try {
      await Future.wait<void>([
        _videoPlayerService.seekTo(Duration.zero),
        _audioPlayerService.seek(Duration.zero),
      ]);

      await Future.wait<void>([
        _videoPlayerService.pause(),
        _audioPlayerService.pause(),
      ]);

      _isVideoPlaying.value = false;
      _animatedControlButtonController.reverse();
    } on SeekVideoPositionException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not reset the video position! An error occurred while '
            'resetting the video position.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    } on PauseVideoException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not pause the video! An error occurred while pausing '
            'the video.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    } on SeekAudioPositionException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not pause the audio! An error occurred while pausing '
            'the audio.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    } on PauseAudioException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not pause the audio! An error occurred while pausing '
            'the audio.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }

    // Removes the listener to prevent more listeners from being added.
    _videoPlayerService.removeListener(_videoListener);
  }

  Future<void> _setVideoPlaybackSpeed(double speed) async {
    try {
      await _videoPlayerService.setPlaybackSpeed(speed);
    } on SetVideoPlaybackSpeedException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not set the video playback speed! An error occurred '
            'while setting the video playback speed.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }

  Future<void> _seekToRequestedVideoDuration(Duration position) async {
    try {
      await _videoPlayerService.seekTo(position);
    } on SeekVideoPositionException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not seek the video to the requested position! An error '
            'occurred while seeking video to the requested position.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }

  Future<void> _pauseAll() async {
    _isVideoPlaying.value = false;
    _videoPlayerService.removeListener(_videoListener);

    try {
      await Future.wait<void>([
        _audioPlayerService.pause(),
        _videoPlayerService.pause(),
      ]);
    } on PauseAudioException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not pause the audio! An error occurred while pausing '
            'the audio.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    } on PauseVideoException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not pause the video! An error occurred while pausing '
            'the video.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }

    _animatedControlButtonController.reverse();
  }

  void setShouldRefreshMediaOff() => _shouldRefreshMedia = false;

  Future<void> onTapPlayButton() async {
    if (_videoPlayerService.isPlaying) {
      await _pauseAll();
      return;
    }

    _videoPlayerService.addListener(_videoListener);

    try {
      await _videoPlayerService.play();
      _isVideoPlaying.value = true;
    } on PlayVideoException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not play the video! An error occurred while playing '
            'the video.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }

    _animatedControlButtonController.forward();

    if (_audioFile == null) return;

    try {
      await _audioPlayerService.play();
    } on PlayAudioException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not play the audio! An error occurred while playing '
            'the audio.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }

  Future<void> setSpeed(double speed) async {
    switch (speed.round()) {
      case 0:
        _speedValueText = '0.25';
        await _setVideoPlaybackSpeed(0.25);
      case 1:
        _speedValueText = '0.50';
        await _setVideoPlaybackSpeed(0.50);
      case 2:
        _speedValueText = '0.75';
        await _setVideoPlaybackSpeed(0.75);
      case 3:
        _speedValueText = '1.00';
        await _setVideoPlaybackSpeed(1);
      case 4:
        _speedValueText = '1.25';
        await _setVideoPlaybackSpeed(1.25);
      case 5:
        _speedValueText = '1.50';
        await _setVideoPlaybackSpeed(1.50);
      case 6:
        _speedValueText = '1.75';
        await _setVideoPlaybackSpeed(1.75);
      case 7:
        _speedValueText = '2.00';
        await _setVideoPlaybackSpeed(2);
      default:
        break;
    }

    await _seekToRequestedVideoDuration(Duration.zero);

    _speedValue.value = speed;
  }

  void setQuality(double quality) {
    switch (quality.round()) {
      case 0:
        _qualityValueText = '240p';
      case 1:
        _qualityValueText = '480p';
      case 2:
        _qualityValueText = '720p';
      case 3:
        _qualityValueText = '1080p';
      case 4:
        _qualityValueText = '1440p';
      case 5:
        _qualityValueText = '2160p';
      case 6:
        _qualityValueText = 'Default';
    }
    _qualityValue.value = quality;
  }

  Future<void> onTapSettingsButton() async {
    if (!_isVideoReady.value) return;

    await _pauseAll();
    await _callSettingsBottomSheet();
  }

  Future<void> _callSettingsBottomSheet() async {
    return showCupertinoModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      useRootNavigator: true,
      elevation: 4,
      topRadius: Radius.zero,
      builder: (_) => const SettingsModalBottomSheet(),
    );
  }

  Future<void> onTapSaveButton() async {
    if (!_isVideoReady.value) return;

    await _pauseAll();
    unawaited(_callSaveBottomSheet());
    unawaited(_wakelockService.enable());

    _progressPercentage.value = 0.0;
    _isProgressCompleted.value = false;

    final path = await _editVideo();
    unawaited(_wakelockService.disable());

    if (path == null) {
      _progressPercentage.value = 0.0;
      _isProgressCompleted.value = true;
    } else {
      await _saveToGallery(path);

      _shouldRefreshMedia = true;
      _progressPercentage.value = 100.0;
      _isProgressCompleted.value = true;
    }
  }

  Future<String?> _editVideo() async {
    final Directory appDocDirectory;
    try {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not get the app directory! An error occurred while '
            'editing the video.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
      return null;
    }

    final outputPath = join(
      appDocDirectory.path,
      'Video-${DateTime.now().millisecondsSinceEpoch}.mp4',
    );

    final speed = _videoPlayerService.playbackSpeed == 1.0
        ? ''
        : '-filter:v setpts=PTS/${_videoPlayerService.playbackSpeed}';

    final quality = _qualityValueText == 'Default'
        ? ''
        : '-vf scale=${_qualityValueText.substring(
            0,
            _qualityValueText.length - 1,
          )}:-2,setsar=1:1';

    if (speed.isNotEmpty || quality.isNotEmpty) {
      final tempPath = join(
        appDocDirectory.path,
        'Temp-${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      if (_audioFile != null) {
        try {
          await _ffmpegKitService.encodeVideoAndReplaceSound(
            videoPath: _videoFile!.path,
            audioPath: _audioFile!.path,
            speed: speed,
            quality: quality,
            tempPath: tempPath,
            outputPath: outputPath,
            percentageCallback: _percentageCallback,
          );
          return outputPath;
        } catch (error, stackTrace) {
          await ErrorService.showDialog(
            context: Get.context!,
            message:
                'Could not edit the video! An error occurred while executing '
                'the command.',
            error: '$error',
            stackTrace: '$stackTrace',
            errorIconPath: kErrorIconPath,
            closeIconPath: kCloseIconPath,
          );
          return null;
        }
      } else {
        try {
          await _ffmpegKitService.encodeVideoAndRemoveSound(
            videoPath: _videoFile!.path,
            speed: speed,
            quality: quality,
            tempPath: tempPath,
            outputPath: outputPath,
            percentageCallback: _percentageCallback,
          );
          return outputPath;
        } catch (error, stackTrace) {
          await ErrorService.showDialog(
            context: Get.context!,
            message:
                'Could not edit the video! An error occurred while executing '
                'the command.',
            error: '$error',
            stackTrace: '$stackTrace',
            errorIconPath: kErrorIconPath,
            closeIconPath: kCloseIconPath,
          );
          return null;
        }
      }
    }

    if (_audioFile != null) {
      try {
        await _ffmpegKitService.replaceSound(
          videoPath: _videoFile!.path,
          audioPath: _audioFile!.path,
          outputPath: outputPath,
          percentageCallback: _percentageCallback,
        );
        return outputPath;
      } catch (error, stackTrace) {
        await ErrorService.showDialog(
          context: Get.context!,
          message:
              'Could not edit the video! An error occurred while executing '
              'the command.',
          error: '$error',
          stackTrace: '$stackTrace',
          errorIconPath: kErrorIconPath,
          closeIconPath: kCloseIconPath,
        );
        return null;
      }
    } else {
      try {
        await _ffmpegKitService.removeSound(
          videoPath: _videoFile!.path,
          outputPath: outputPath,
          percentageCallback: _percentageCallback,
        );

        return outputPath;
      } catch (error, stackTrace) {
        await ErrorService.showDialog(
          context: Get.context!,
          message:
              'Could not edit the video! An error occurred while executing '
              'the command.',
          error: '$error',
          stackTrace: '$stackTrace',
          errorIconPath: kErrorIconPath,
          closeIconPath: kCloseIconPath,
        );
        return null;
      }
    }
  }

  void _percentageCallback(double percentage) {
    _progressPercentage.value = percentage > 100 ? 100 : percentage;
  }

  Future<void> _callSaveBottomSheet() async {
    await showCupertinoModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      useRootNavigator: true,
      elevation: 4,
      topRadius: Radius.zero,
      isDismissible: false,
      builder: (_) => const SaveModalBottomSheet(),
    );
  }

  Future<void> _saveToGallery(String path) async {
    try {
      await ImageGallerySaver.saveFile(path);
    } catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not edit the video! An error occurred while executing ',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }

    await _deleteFiles();
  }

  Future<void> _deleteFiles() async {
    try {
      final appDocDirectory = await getApplicationDocumentsDirectory();
      Directory(appDocDirectory.path).deleteSync(recursive: true);
    } catch (_) {
      developer.log(
        'Could not delete the generated video!',
        name: 'DeleteFile',
      );
    }
  }

  Future<void> updateSelectedSoundIndex(int index) async {
    if (!isVideoReady) return;

    _selectedSoundIndex.value = index;
    await _pauseAll();
    await _seekToRequestedVideoDuration(Duration.zero);

    if (index != -1) {
      try {
        _audioFile = await audios[index].loadFile();
      } catch (error, stackTrace) {
        await ErrorService.showDialog(
          context: Get.context!,
          message:
              'Could not load the audio file! An error occurred while loading '
              'the audio file.',
          error: '$error',
          stackTrace: '$stackTrace',
          errorIconPath: kErrorIconPath,
          closeIconPath: kCloseIconPath,
        );
        _audioFile = null;
      }

      if (_audioFile == null) return;

      try {
        await _audioPlayerService.load(_audioFile!.path);
        _isAudioReady.value = true;
      } catch (error, stackTrace) {
        await ErrorService.showDialog(
          context: Get.context!,
          message:
              'Could not load the audio file! An error occurred while loading '
              'the audio file.',
          error: '$error',
          stackTrace: '$stackTrace',
          errorIconPath: kErrorIconPath,
          closeIconPath: kCloseIconPath,
        );
        _audioFile = null;
        _isAudioReady.value = false;
      }
    }
  }
}
