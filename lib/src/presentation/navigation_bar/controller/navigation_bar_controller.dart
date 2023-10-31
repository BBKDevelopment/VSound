// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vsound/src/core/core.dart';
import 'package:vsound/src/presentation/presentation.dart';

class NavigationBarController extends GetxController {
  NavigationBarController()
      : _pageController = PageController(),
        _currentIndex = 0.obs;

  final PageController _pageController;
  final RxInt _currentIndex;

  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex.value;

  set currentIndex(int index) => _currentIndex.value = index;

  Future<void> onItemSelected(int index) async {
    final navigationBarController = Get.find<NavigationBarController>();

    if (navigationBarController.currentIndex == 0 && index != 0) {
      final selectViewController = Get.find<SelectViewController>();

      selectViewController.getAnimationController.duration =
          AnimationDuration.homePageOut;
      await selectViewController.getAnimationController.reverse();
    }

    if (navigationBarController.currentIndex == 1 && index != 1) {
      final editViewController = Get.find<EditViewController>();

      editViewController.animationController.duration =
          AnimationDuration.editPageOut;
      await editViewController.animationController.reverse();
    }

    if (navigationBarController.currentIndex == 2 && index != 2) {
      final moreViewController = Get.find<MoreViewController>();

      moreViewController.getAnimationController.duration =
          AnimationDuration.morePageOut;
      await moreViewController.getAnimationController.reverse();
    }

    navigationBarController.currentIndex = index;
    navigationBarController.pageController.jumpToPage(index);
  }
}
