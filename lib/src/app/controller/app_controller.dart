// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shared_preferences_service/shared_preferences_service.dart';
import 'package:vsound/src/config/config.dart';
import 'package:vsound/src/core/core.dart';
import 'package:vsound/src/presentation/presentation.dart';

class AppController extends GetxController {
  AppController({
    required SharedPreferencesService sharedPreferencesService,
  })  : _navigationBarController = Get.find(),
        _selectViewController = Get.find(),
        _editViewController = Get.find(),
        _moreViewController = Get.find(),
        _sharedPreferencesService = sharedPreferencesService,
        _appTheme = AppTheme.light.obs;

  final NavigationBarController _navigationBarController;
  final SelectViewController _selectViewController;
  final EditViewController _editViewController;
  final MoreViewController _moreViewController;
  final SharedPreferencesService _sharedPreferencesService;
  final Rx<AppTheme> _appTheme;

  AppTheme get getAppTheme => _appTheme.value;

  @override
  Future<void> onReady() async {
    super.onReady();

    // Loads theme.
    await _loadTheme();

    // Removes splash screen.
    FlutterNativeSplash.remove();
  }

  Future<void> _loadTheme() async {
    final String theme;
    try {
      theme = _sharedPreferencesService.getString(key: kThemeKey);
    } on UnexpectedValueTypeException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not get theme! An error occurred while getting theme.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
      return;
    } on KeyNotFoundException catch (_) {
      await setTheme(_appTheme.value);
      return;
    }

    final appTheme =
        AppTheme.values.firstWhereOrNull((appTheme) => appTheme.name == theme);

    // Sets theme.
    await setTheme(appTheme ?? _appTheme.value);
  }

  Future<void> setTheme(AppTheme theme) async {
    _appTheme.value = theme;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: theme.data.primaryColor,
      ),
    );

    try {
      await _sharedPreferencesService.setString(
        key: kThemeKey,
        value: theme.toString(),
      );
    } on SetValueException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not set theme! An error occurred while setting theme.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }

  Future<void> onPageChanged(int index) async {
    _navigationBarController.currentIndex = index;

    if (index == 0) {
      if (_editViewController.shouldRefreshMedia) {
        _editViewController.setShouldRefreshMediaOff();
        await _selectViewController.getMedia();
      }

      _selectViewController.getAnimationController.duration =
          AnimationDuration.homePageIn;

      await _selectViewController.getAnimationController.forward();
    }
    if (index == 1) {
      if (_selectViewController.shouldRefreshMedia) {
        _selectViewController.setShouldRefreshMediaOff();
        await _editViewController.getMedia();
      }

      _editViewController.animationController.duration =
          AnimationDuration.editPageIn;

      await _editViewController.animationController.forward();
    }
    if (index == 2) {
      _moreViewController.getAnimationController.duration =
          AnimationDuration.morePageIn;

      await _moreViewController.getAnimationController.forward();
    }
  }
}
