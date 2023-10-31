// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../edit_view.dart';

class _SlideTransitionWidget extends StatelessWidget {
  const _SlideTransitionWidget(
    this.child, {
    required this.beginOffset,
    this.prior = true,
  });

  final Widget? child;
  final Offset beginOffset;
  final bool prior;

  @override
  Widget build(BuildContext context) {
    final editViewController = Get.find<EditViewController>();

    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: editViewController.animation,
          curve: Interval(
            prior ? 0.0 : 0.50,
            prior ? 0.50 : 1.0,
            curve: Curves.easeInOutCubic,
          ),
        ),
      ),
      child: child,
    );
  }
}
