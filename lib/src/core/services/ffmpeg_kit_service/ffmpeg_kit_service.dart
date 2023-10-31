// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:developer';

import 'package:ffmpeg_kit_flutter_https_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/return_code.dart';

/// An exception thrown when a FFmpegKit fails to execute.
class FFmpegKitExecuteException implements Exception {}

/// An exception thrown when a FFmpegKit fails to execute because it was
/// canceled.
class CanceledExecuteException implements FFmpegKitExecuteException {}

/// An exception thrown when a return code is not success.
class NullReturnCodeException implements Exception {}

/// {@template ffmpeg_kit_service}
/// A service that provides FFmpegKit functionality.
///
/// This service is a wrapper around the [FFmpegKit] class.
///
/// ```dart
/// final ffmpegKitService = FFmpegKitService();
/// ```
/// {@endtemplate}
class FFmpegKitService {
  /// {@macro ffmpeg_kit_service}
  const FFmpegKitService();

  /// Replaces the sound of a video with another sound. Requires the [videoPath],
  /// [audioPath], [outputPath], and [percentageCallback] parameters.
  ///
  ///
  /// Throws a [FFmpegKitExecuteException] if the FFmpegKit fails to execute.
  ///
  /// Throws a [NullReturnCodeException] if the return code is not success.
  ///
  /// Throws a [CanceledExecuteException] if the FFmpegKit was canceled.
  Future<void> replaceSound({
    required String videoPath,
    required String audioPath,
    required String outputPath,
    required void Function(double) percentageCallback,
  }) async {
    unawaited(_enableStatistics(path: videoPath, callback: percentageCallback));

    videoPath = '"$videoPath"';
    audioPath = '"$audioPath"';
    outputPath = '"$outputPath"';

    final FFmpegSession session;
    final ReturnCode? returnCode;
    try {
      session = await FFmpegKit.execute(
        '-i $videoPath -i $audioPath -y -safe 0 -c:v copy -map 0:v:0 -map 1:a:0 $outputPath',
      );
      returnCode = await session.getReturnCode();
    } catch (_) {
      log('Failed to replace sound!', name: 'FFmpegKitService');
      throw FFmpegKitExecuteException();
    }

    unawaited(_disableStatistics());

    if (returnCode == null) {
      log('Failed to get return code!', name: 'FFmpegKitService');
      throw NullReturnCodeException();
    }

    if (ReturnCode.isSuccess(returnCode)) return;

    if (ReturnCode.isCancel(returnCode)) {
      log('FFmpegKit was canceled!', name: 'FFmpegKitService');
      throw CanceledExecuteException();
    }
  }

  /// Encodes a video and replaces the sound with another sound. Requires the
  /// [videoPath], [audioPath], [speed], [quality], [tempPath], [outputPath],
  /// and [percentageCallback] parameters.
  ///
  ///
  /// Throws a [FFmpegKitExecuteException] if the FFmpegKit fails to execute.
  ///
  /// Throws a [NullReturnCodeException] if the return code is not success.
  ///
  /// Throws a [CanceledExecuteException] if the FFmpegKit was canceled.
  Future<void> encodeVideoAndReplaceSound({
    required String videoPath,
    required String audioPath,
    required String speed,
    required String quality,
    required String tempPath,
    required String outputPath,
    required void Function(double) percentageCallback,
  }) async {
    unawaited(
      _enableStatistics(
        path: videoPath,
        callback: percentageCallback,
        speed: speed,
      ),
    );

    videoPath = '"$videoPath"';
    audioPath = '"$audioPath"';
    tempPath = '"$tempPath"';
    outputPath = '"$outputPath"';

    if (speed.isNotEmpty && quality.isNotEmpty) {
      final FFmpegSession speedSession;
      final FFmpegSession qualitySession;
      final ReturnCode? speedSessionReturnCode;
      final ReturnCode? qualitySessionReturnCode;
      try {
        speedSession = await FFmpegKit.execute(
          '-i $videoPath -i $audioPath -y -safe 0 -vcodec libx264 -map 0:v -map 1:a $speed $tempPath',
        );
        qualitySession = await FFmpegKit.execute(
          '-i $tempPath -y -safe 0 -vcodec libx264 $quality $outputPath',
        );
        speedSessionReturnCode = await speedSession.getReturnCode();
        qualitySessionReturnCode = await qualitySession.getReturnCode();
      } catch (_) {
        log(
          'Failed to encode video and replace sound!',
          name: 'FFmpegKitService',
        );
        throw FFmpegKitExecuteException();
      }

      unawaited(_disableStatistics());

      if (speedSessionReturnCode == null || qualitySessionReturnCode == null) {
        log('Failed to get return code!', name: 'FFmpegKitService');
        throw NullReturnCodeException();
      }

      if (ReturnCode.isSuccess(speedSessionReturnCode) &&
          ReturnCode.isSuccess(qualitySessionReturnCode)) {
        return;
      }

      if (ReturnCode.isCancel(speedSessionReturnCode) ||
          ReturnCode.isCancel(qualitySessionReturnCode)) {
        log('FFmpegKit was canceled!', name: 'FFmpegKitService');
        throw CanceledExecuteException();
      }
    } else if (speed.isNotEmpty) {
      final FFmpegSession session;
      final ReturnCode? returnCode;
      try {
        session = await FFmpegKit.execute(
          '-i $videoPath -i $audioPath -y -safe 0 -vcodec libx264 -map 0:v -map 1:a $speed $outputPath',
        );
        returnCode = await session.getReturnCode();
      } catch (_) {
        log(
          'Failed to encode video and replace sound!',
          name: 'FFmpegKitService',
        );
        throw FFmpegKitExecuteException();
      }

      unawaited(_disableStatistics());

      if (returnCode == null) {
        log('Failed to get return code!', name: 'FFmpegKitService');
        throw NullReturnCodeException();
      }

      if (ReturnCode.isSuccess(returnCode)) return;

      if (ReturnCode.isCancel(returnCode)) {
        log('FFmpegKit was canceled!', name: 'FFmpegKitService');
        throw CanceledExecuteException();
      }
    } else {
      final FFmpegSession session;
      final ReturnCode? returnCode;
      try {
        session = await FFmpegKit.execute(
          '-i $videoPath -i $audioPath -y -safe 0 -vcodec libx264 -map 0:v -map 1:a $quality $outputPath',
        );
        returnCode = await session.getReturnCode();
      } catch (_) {
        log(
          'Failed to encode video and replace sound!',
          name: 'FFmpegKitService',
        );
        throw FFmpegKitExecuteException();
      }

      unawaited(_disableStatistics());

      if (returnCode == null) {
        log('Failed to get return code!', name: 'FFmpegKitService');
        throw NullReturnCodeException();
      }

      if (ReturnCode.isSuccess(returnCode)) return;

      if (ReturnCode.isCancel(returnCode)) {
        log('FFmpegKit was canceled!', name: 'FFmpegKitService');
        throw CanceledExecuteException();
      }
    }
  }

  /// Removes the sound from a video. Requires the [videoPath], [outputPath],
  /// and [percentageCallback] parameters.
  ///
  /// Throws a [FFmpegKitExecuteException] if the FFmpegKit fails to execute.
  ///
  /// Throws a [NullReturnCodeException] if the return code is not success.
  ///
  /// Throws a [CanceledExecuteException] if the FFmpegKit was canceled.
  Future<void> removeSound({
    required String videoPath,
    required String outputPath,
    required void Function(double) percentageCallback,
  }) async {
    unawaited(_enableStatistics(path: videoPath, callback: percentageCallback));

    videoPath = '"$videoPath"';
    outputPath = '"$outputPath"';

    final FFmpegSession session;
    final ReturnCode? returnCode;
    try {
      session = await FFmpegKit.execute(
        '-i $videoPath -y -safe 0 -c copy -map 0:v:0 -an $outputPath',
      );
      returnCode = await session.getReturnCode();
    } catch (_) {
      log('Failed to remove sound!', name: 'FFmpegKitService');
      throw FFmpegKitExecuteException();
    }

    unawaited(_disableStatistics());

    if (returnCode == null) {
      log('Failed to get return code!', name: 'FFmpegKitService');
      throw NullReturnCodeException();
    }

    if (ReturnCode.isSuccess(returnCode)) return;

    if (ReturnCode.isCancel(returnCode)) {
      log('FFmpegKit was canceled!', name: 'FFmpegKitService');
      throw CanceledExecuteException();
    }
  }

  /// Encodes a video and removes the sound. Requires the [videoPath], [speed],
  /// [quality], [tempPath], [outputPath], and [percentageCallback] parameters.
  ///
  /// Throws a [FFmpegKitExecuteException] if the FFmpegKit fails to execute.
  ///
  /// Throws a [NullReturnCodeException] if the return code is not success.
  ///
  /// Throws a [CanceledExecuteException] if the FFmpegKit was canceled.
  Future<void> encodeVideoAndRemoveSound({
    required String videoPath,
    required String speed,
    required String quality,
    required String tempPath,
    required String outputPath,
    required void Function(double) percentageCallback,
  }) async {
    unawaited(
      _enableStatistics(
        path: videoPath,
        callback: percentageCallback,
        speed: speed,
      ),
    );

    videoPath = '"$videoPath"';
    tempPath = '"$tempPath"';
    outputPath = '"$outputPath"';

    if (speed.isNotEmpty && quality.isNotEmpty) {
      final FFmpegSession speedSession;
      final FFmpegSession qualitySession;
      final ReturnCode? speedSessionReturnCode;
      final ReturnCode? qualitySessionReturnCode;
      try {
        speedSession = await FFmpegKit.execute(
          '-i $videoPath -y -safe 0 -vcodec libx264 -map 0:v $speed $tempPath',
        );

        qualitySession = await FFmpegKit.execute(
          '-i $tempPath -y -safe 0 -vcodec libx264 -map 0:v -an $quality $outputPath',
        );
        speedSessionReturnCode = await speedSession.getReturnCode();
        qualitySessionReturnCode = await qualitySession.getReturnCode();
      } catch (_) {
        log(
          'Failed to encode video and remove sound!',
          name: 'FFmpegKitService',
        );
        throw FFmpegKitExecuteException();
      }

      unawaited(_disableStatistics());

      if (speedSessionReturnCode == null || qualitySessionReturnCode == null) {
        log('Failed to get return code!', name: 'FFmpegKitService');
        throw NullReturnCodeException();
      }

      if (ReturnCode.isSuccess(speedSessionReturnCode) &&
          ReturnCode.isSuccess(qualitySessionReturnCode)) {
        return;
      }

      if (ReturnCode.isCancel(speedSessionReturnCode) ||
          ReturnCode.isCancel(qualitySessionReturnCode)) {
        throw CanceledExecuteException();
      }
    } else if (speed.isNotEmpty) {
      final FFmpegSession session;
      final ReturnCode? returnCode;
      try {
        session = await FFmpegKit.execute(
          '-i $videoPath -y -safe 0 -vcodec libx264 -map 0:v -an $speed $outputPath',
        );
        returnCode = await session.getReturnCode();
      } catch (_) {
        log(
          'Failed to encode video and remove sound!',
          name: 'FFmpegKitService',
        );
        throw FFmpegKitExecuteException();
      }

      unawaited(_disableStatistics());

      if (returnCode == null) {
        log('Failed to get return code!', name: 'FFmpegKitService');
        throw NullReturnCodeException();
      }

      if (ReturnCode.isSuccess(returnCode)) return;

      if (ReturnCode.isCancel(returnCode)) {
        log('FFmpegKit was canceled!', name: 'FFmpegKitService');
        throw CanceledExecuteException();
      }
    } else {
      final FFmpegSession session;
      final ReturnCode? returnCode;
      try {
        session = await FFmpegKit.execute(
          '-i $videoPath -y -safe 0 -vcodec libx264 -map 0:v -an $quality $outputPath',
        );
        returnCode = await session.getReturnCode();
      } catch (_) {
        log(
          'Failed to encode video and remove sound!',
          name: 'FFmpegKitService',
        );
        throw FFmpegKitExecuteException();
      }

      unawaited(_disableStatistics());

      if (returnCode == null) {
        log('Failed to get return code!', name: 'FFmpegKitService');
        throw NullReturnCodeException();
      }

      if (ReturnCode.isSuccess(returnCode)) return;

      if (ReturnCode.isCancel(returnCode)) {
        log('FFmpegKit was canceled!', name: 'FFmpegKitService');
        throw CanceledExecuteException();
      }
    }
  }

  /// Enables statistics. Requires the [path] and [callback] parameters.
  /// Optionally requires the [speed] parameter.
  Future<void> _enableStatistics({
    required String path,
    required void Function(double) callback,
    String? speed,
  }) async {
    try {
      await FFmpegKitConfig.enableStatistics();

      final mediaInfo = await FFprobeKit.getMediaInformation(path);
      final info = mediaInfo.getMediaInformation();
      var duration = double.tryParse(info?.getDuration() ?? '0') ?? 0;
      duration = speed != null
          ? duration / (double.tryParse(speed.split('/').last) ?? 0)
          : duration;

      FFmpegKitConfig.enableStatisticsCallback((statistics) {
        final percentage = (statistics.getTime() / 1000) / duration * 100;

        callback(percentage);
      });
    } catch (_) {
      log('Error enable statistics!', name: 'FFmpegKitService');
    }
  }

  /// Disables statistics.
  Future<void> _disableStatistics() async {
    try {
      await FFmpegKitConfig.disableStatistics();
    } catch (_) {
      log('Error disable statistics!', name: 'FFmpegKitService');
    }
  }
}
