// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../more_view.dart';

class _CopyrightWidget extends StatelessWidget {
  const _CopyrightWidget();

  @override
  Widget build(BuildContext context) {
    final moreViewController = Get.find<MoreViewController>();

    return AnimatedBuilder(
      animation: moreViewController.getAnimation,
      builder: (_, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: moreViewController.getAnimation,
            curve: Interval(
              moreViewController.getMoreItemList.isEmpty ? 0.0 : 0.6,
              1,
              curve: Curves.easeInOutCubic,
            ),
          ),
          child: child,
        );
      },
      child: Text(
        kCopyrightText,
        style: context.textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
