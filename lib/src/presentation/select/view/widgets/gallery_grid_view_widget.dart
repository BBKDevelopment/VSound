// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../select_view.dart';

class _GalleryGridViewWidget extends StatelessWidget {
  const _GalleryGridViewWidget();

  @override
  Widget build(BuildContext context) {
    final selectViewController = Get.find<SelectViewController>();

    return GridView.count(
      cacheExtent: Get.height * 5,
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(
        horizontal: kHorizontalSpace,
        vertical: kVerticalSpace,
      ),
      childAspectRatio: kVideoItemAspectRatio,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: List.generate(
        selectViewController.videos.length,
        (index) {
          return VideoThumbnail(
            selectViewController.videos[index],
            onTap: () => selectViewController.onTapVideoThumbnail(index),
          );
        },
      ),
    );
  }
}
