// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

class AnimatedControlButtonController {
  late void Function() forward;
  late void Function() reverse;
}

class AnimatedControlButton extends StatefulWidget {
  const AnimatedControlButton({
    required this.controller,
    this.onTap,
    this.size = 32.0,
    super.key,
  });

  final AnimatedControlButtonController controller;
  final void Function()? onTap;
  final double size;

  @override
  State<AnimatedControlButton> createState() => _AnimatedControlButtonState();
}

class _AnimatedControlButtonState extends State<AnimatedControlButton>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    initController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initController() {
    widget.controller.forward = () async {
      if (mounted) {
        await controller.forward();
      }
    };

    widget.controller.reverse = () async {
      if (mounted) {
        await controller.reverse();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.12,
        width: MediaQuery.of(context).size.width * 0.12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).focusColor,
        ),
        child: Center(
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: controller,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
