// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../edit_view.dart';

class _NoSoundWidget extends StatelessWidget {
  const _NoSoundWidget({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final editViewController = Get.find<EditViewController>();

    return AutoScrollTag(
      key: ValueKey(index),
      controller: editViewController.autoScrollController,
      index: index,
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        highlightColor: Colors.transparent,
        onTap: () async {
          await editViewController.autoScrollController.scrollToIndex(
            index,
            duration: const Duration(milliseconds: 400),
            preferPosition: AutoScrollPosition.begin,
          );
          await editViewController.updateSelectedSoundIndex(index);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kGridViewItemsBorderRadius),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 40,
                color: context.theme.colorScheme.secondary,
                child: Obx(
                  () => Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: index == editViewController.selectedSoundIndex
                            ? 0.0
                            : 1.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                        child: Icon(
                          Icons.music_off,
                          color: context.theme.primaryColor,
                          size: kLargeIconSize,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: index == editViewController.selectedSoundIndex
                            ? 1.0
                            : 0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                        child: Icon(
                          Icons.check,
                          color: context.theme.primaryColor,
                          size: kLargeIconSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border:
                        Border.all(color: context.theme.colorScheme.secondary),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        kTitleText,
                        style: context.textTheme.bodySmall,
                      ),
                      Text(
                        '-',
                        style: context.textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        kDurationText,
                        style: context.textTheme.bodySmall,
                      ),
                      Text(
                        '-',
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
