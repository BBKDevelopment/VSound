// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../edit_view.dart';

class _SoundWidget extends StatelessWidget {
  const _SoundWidget(this.index);

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
        child: _GridViewItem(index: index),
      ),
    );
  }
}

class _GridViewItem extends StatelessWidget with TimeFormationMixin {
  const _GridViewItem({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final editViewController = Get.find<EditViewController>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(kGridViewItemsBorderRadius),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 40,
            color: context.theme.colorScheme.secondary,
            child: Obx(
              () {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: index == editViewController.selectedSoundIndex
                          ? 0.0
                          : 1.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic,
                      child: Icon(
                        Icons.music_note,
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
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: context.theme.colorScheme.secondary),
              ),
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Title:',
                    style: context.textTheme.bodySmall,
                  ),
                  TextScroll(
                    basenameWithoutExtension(
                      editViewController.audios[index].title ?? '',
                    ),
                    style: context.textTheme.bodyMedium,
                    velocity: const Velocity(pixelsPerSecond: Offset(10, 0)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Duration:',
                    style: context.textTheme.bodySmall,
                  ),
                  Text(
                    formatDuration(
                      duration: Duration(
                        seconds: editViewController.audios[index].duration,
                      ),
                    ),
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
