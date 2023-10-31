// Copyright 2022 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:vsound/bootstrap.dart';
import 'package:vsound/src/app/app.dart';
import 'package:vsound/src/injection.dart' as di;
import 'package:vsound/src/presentation/presentation.dart';

Future<void> main() async {
  // Ensures that the Flutter binding has been initialized.
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keeps the splash screen visible until Flutter renders its first frame.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Sets status bar color.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: const Color(0xFF181818),
    ),
  );

  // Sets preferred orientation.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initializes dependencies.
  await di.init();

  // Initializes controllers.
  Get
    ..put<NavigationBarController>(NavigationBarController())
    ..put<SelectViewController>(
      SelectViewController(photoManagerService: di.sl()),
    )
    ..put<EditViewController>(
      EditViewController(
        photoManagerService: di.sl(),
        videoPlayerService: di.sl(),
        audioPlayerService: di.sl(),
        ffmpegKitService: di.sl(),
        wakelockService: di.sl(),
      ),
    )
    ..put<MoreViewController>(
      MoreViewController(
        urlLauncherService: di.sl(),
        launchReviewService: di.sl(),
      ),
    )
    ..put<AppController>(AppController(sharedPreferencesService: di.sl()));

  // Runs app.
  await bootstrap(() => const App());
}
