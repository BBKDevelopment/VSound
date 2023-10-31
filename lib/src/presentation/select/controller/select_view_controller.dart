// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_service/photo_manager_service.dart';
import 'package:vsound/src/core/core.dart';
import 'package:vsound/src/presentation/presentation.dart';

class SelectViewController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  SelectViewController({
    required PhotoManagerService photoManagerService,
  })  : _photoManagerService = photoManagerService,
        _videos = <AssetEntity>[].obs,
        _isMediaReady = false.obs,
        _shouldRefreshMedia = false,
        _shouldCheckPermission = false;

  final PhotoManagerService _photoManagerService;
  final RxList<AssetEntity> _videos;
  final RxBool _isMediaReady;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  bool _shouldRefreshMedia;
  bool _shouldCheckPermission;

  bool get isMediaReady => _isMediaReady.value;
  bool get shouldRefreshMedia => _shouldRefreshMedia;
  List<AssetEntity> get videos => _videos;
  AnimationController get getAnimationController => _animationController;
  Animation<double> get getAnimation => _animation;

  @override
  Future<void> onInit() async {
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: AnimationDuration.homePageIn,
    );

    _animation = Tween(begin: 0.toDouble(), end: 1.toDouble())
        .animate(_animationController);

    await _requestPermission();
    await getMedia();

    await _animationController.forward();
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) return;

    if (_shouldCheckPermission) {
      _shouldCheckPermission = false;

      await getMedia();
    }
  }

  void setShouldRefreshMediaOff() {
    _shouldRefreshMedia = false;
  }

  Future<void> onTapOpenSettings() async {
    _shouldCheckPermission = true;

    await _openSettings();
  }

  Future<void> onTapVideoThumbnail(int index) async {
    final selectViewController = Get.find<SelectViewController>();
    final editViewController = Get.find<EditViewController>();
    final navigationBarController = Get.find<NavigationBarController>();

    await selectViewController.getAnimationController.reverse();

    await editViewController.setFile(selectViewController.videos[index].file);

    navigationBarController.pageController.jumpToPage(1);
  }

  Future<void> getMedia() async {
    if (isMediaReady) _isMediaReady.value = false;

    if (!_photoManagerService.isAuthenticated) {
      if (!await _requestPermission()) return;
    }

    await _getVideos();

    _shouldRefreshMedia = true;
    _isMediaReady.value = true;
  }

  Future<bool> _requestPermission() async {
    try {
      await _photoManagerService.requestPermission();
      return true;
    } on PermissionException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message:
            'Could not get permission to access media! Please open settings '
            'and allow access to media.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
      return false;
    }
  }

  Future<void> _getVideos() async {
    try {
      _videos.value = await _photoManagerService.getVideos();
    } on PermissionException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message:
            'Could not get permission to access media! Please open settings '
            'and allow access to media.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    } on GetVideoException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message:
            'Could not get videos! An error occurred while getting videos.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }

  Future<void> _openSettings() async {
    try {
      await _photoManagerService.openSettings();
    } on GetVideoException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not open settings! An error occurred while opening '
            'settings.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }
}
