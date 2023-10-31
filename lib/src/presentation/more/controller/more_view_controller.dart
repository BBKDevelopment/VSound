// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launch_review_service/launch_review_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher_service/url_launcher_service.dart';
import 'package:vsound/src/app/app.dart';
import 'package:vsound/src/config/config.dart';
import 'package:vsound/src/core/core.dart';
import 'package:vsound/src/presentation/presentation.dart';

class MoreViewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  MoreViewController({
    required UrlLauncherService urlLauncherService,
    required LaunchReviewService launchReviewService,
  })  : _urlLauncherService = urlLauncherService,
        _launchReviewService = launchReviewService,
        _selectedThemeIndex = 0.obs,
        _moreItemList = [],
        _isThemeSwitchBusy = false;

  final UrlLauncherService _urlLauncherService;
  final LaunchReviewService _launchReviewService;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  final RxInt _selectedThemeIndex;
  final List<MoreItem> _moreItemList;
  bool _isThemeSwitchBusy;

  AnimationController get getAnimationController => _animationController;
  Animation<double> get getAnimation => _animation;
  int get getSelectedThemeIndex => _selectedThemeIndex.value;
  List<MoreItem> get getMoreItemList => _moreItemList;

  @override
  void onInit() {
    _animationController = AnimationController(
      vsync: this,
      duration: AnimationDuration.morePageIn,
    );
    _animation = Tween(begin: 0.toDouble(), end: 1.toDouble())
        .animate(_animationController);
    _createItemsForMorePage();
    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    _moreItemList.clear();
    super.onClose();
  }

  void _createItemsForMorePage() {
    _moreItemList
      ..add(const MoreItem(iconPath: kSettingsIconPath, title: kSettingsText))
      ..add(const MoreItem(iconPath: kStarIconPath, title: kRateText))
      ..add(const MoreItem(iconPath: kMailIconPath, title: kContactsText))
      ..add(const MoreItem(iconPath: kTermsIconPath, title: kTermsText))
      ..add(const MoreItem(iconPath: kPrivacyIconPath, title: kPrivacyText));
  }

  Future<void> onTapListTile({
    required int index,
    required Widget settings,
  }) async {
    switch (index) {
      case 0:
        await _callSettingsBottomSheet(child: settings);
      case 1:
        await _lauchReview();
      case 2:
        await _sendMail();
      case 3:
        await _launchUrl(url: kTermsAndConditionsLink);
      case 4:
        await _launchUrl(url: kPrivacyPolicyLink);
    }
  }

  Future<void> _callSettingsBottomSheet({required Widget child}) async {
    _selectedThemeIndex.value = Get.find<AppController>().getAppTheme.index;
    await showCupertinoModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      useRootNavigator: true,
      elevation: 4,
      topRadius: Radius.zero,
      builder: (context) => child,
    );
  }

  Future<void> _lauchReview() async {
    try {
      await _launchReviewService.launch();
    } on LaunchReviewException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not launch review! An error occurred while launching.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }

  Future<void> _sendMail() async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: kContactMail,
      queryParameters: {'subject': kAppNameText},
    );

    try {
      await _urlLauncherService.sendEmail(emailUri: emailUri);
    } on SendEmailException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message:
            'Could not send email! An error occurred while opening the email '
            'app.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }

  Future<void> _launchUrl({required String url}) async {
    try {
      await _urlLauncherService.launch(url: Uri.parse(url));
    } on UrlLaunchException catch (error, stackTrace) {
      await ErrorService.showDialog(
        context: Get.context!,
        message: 'Could not launch url! An error occurred while opening the '
            'browser.',
        error: '$error',
        stackTrace: '$stackTrace',
        errorIconPath: kErrorIconPath,
        closeIconPath: kCloseIconPath,
      );
    }
  }

  Future<void> onTapThemeSwitch(int index) async {
    if (_isThemeSwitchBusy) return;
    if (_selectedThemeIndex.value == index) return;

    _isThemeSwitchBusy = true;

    await Get.find<AppController>().setTheme(AppTheme.values[index]);
    _selectedThemeIndex.value = index;

    _isThemeSwitchBusy = false;
  }
}
