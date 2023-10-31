// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../edit_view.dart';

class _VideoPlayerWidget extends StatelessWidget {
  const _VideoPlayerWidget();

  @override
  Widget build(BuildContext context) {
    final editViewController = Get.find<EditViewController>();

    return Stack(
      children: [
        Positioned.fill(
          child: FittedBox(
            child: SizedBox(
              height: editViewController.videoPlayerService.height,
              width: editViewController.videoPlayerService.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kVideoBorderRadius),
                child: VideoPlayer(
                  editViewController.videoPlayerService.controller!,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: editViewController.onTapPlayButton,
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: editViewController.isVideoPlaying ? 0.0 : 1.0,
              child: AnimatedControlButton(
                controller: editViewController.animatedControlButtonController,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
