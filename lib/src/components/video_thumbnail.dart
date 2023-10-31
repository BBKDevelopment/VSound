// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail(
    this.assetEntity, {
    required this.onTap,
    super.key,
  });

  final AssetEntity assetEntity;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: assetEntity.thumbnailDataWithSize(const ThumbnailSize(256, 256)),
      builder: (_, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) return const _LoadingGridViewItem();

        return InkWell(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: _LoadedGridViewItem(
            image: bytes,
            duration: assetEntity.duration,
          ),
        );
      },
    );
  }
}

class _LoadingGridViewItem extends StatelessWidget {
  const _LoadingGridViewItem();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      child: Center(
        child: SizedBox(
          height: 28,
          width: 28,
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

class _LoadedGridViewItem extends StatelessWidget {
  const _LoadedGridViewItem({required this.image, required this.duration});

  final Uint8List image;
  final int duration;

  String formatDuration({required Duration duration}) {
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours.remainder(60).toString().padLeft(2, '0');
    return hours != '00' ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          bottom: 8,
          child: DottedBorder(
            color: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.all(4),
            radius: const Radius.circular(1),
            dashPattern: const [6, 6],
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: Image.memory(image, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
            borderRadius: BorderRadius.circular(1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 10,
            ),
            child: Text(
              formatDuration(
                duration: Duration(seconds: duration),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }
}
