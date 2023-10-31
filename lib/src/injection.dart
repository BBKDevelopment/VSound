// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:audio_player_service/audio_player_service.dart';
import 'package:get_it/get_it.dart';
import 'package:launch_review_service/launch_review_service.dart';
import 'package:photo_manager_service/photo_manager_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_service/shared_preferences_service.dart';
import 'package:url_launcher_service/url_launcher_service.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vsound/src/core/core.dart';
import 'package:wakelock_service/wakelock_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);

  //! Src - Core
  sl
    ..registerSingleton<AudioPlayerService>(AudioPlayerService())
    ..registerSingleton<FFmpegKitService>(const FFmpegKitService())
    ..registerSingleton<UrlLauncherService>(const UrlLauncherService())
    ..registerSingleton<PhotoManagerService>(PhotoManagerService())
    ..registerSingleton<LaunchReviewService>(
      const LaunchReviewService(androidAppId: kAndroidAppId),
    )
    ..registerSingleton<SharedPreferencesService>(
      SharedPreferencesService(sharedPreferences: sharedPreferences),
    )
    ..registerSingleton<VideoPlayerService>(
      VideoPlayerService(options: videoPlayerOptions),
    )
    ..registerSingleton<WakelockService>(const WakelockService());
}
