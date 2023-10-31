// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../edit_view.dart';

class SaveModalBottomSheet extends StatelessWidget {
  const SaveModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final editViewController = Get.find<EditViewController>();

    return Material(
      color: context.theme.colorScheme.background,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.theme.colorScheme.secondary),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalSpace,
              vertical: kLongVerticalSpace,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: kIconSize),
                    Hero(
                      tag: HeroTag.save,
                      child: SvgPicture.asset(
                        kSaveIconPath,
                        colorFilter: ColorFilter.mode(
                          context.theme.iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                        height: 10.h,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (!editViewController.isProgressCompleted) return;

                        Get.back<void>();
                      },
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      highlightColor: Colors.transparent,
                      child: Obx(
                        () {
                          return editViewController.isProgressCompleted
                              ? SvgPicture.asset(
                                  kCloseIconPath,
                                  colorFilter: ColorFilter.mode(
                                    context.theme.iconTheme.color!,
                                    BlendMode.srcIn,
                                  ),
                                  width: kIconSize,
                                )
                              : const SizedBox(width: kIconSize);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kVerticalSpace),
                Text(
                  kSaveToAlbumText,
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(height: kVeryLongVerticalSpace),
                const _TimeSlider(),
                const SizedBox(height: kLongVerticalSpace),
                Obx(
                  () => Text(
                    editViewController.isProgressCompleted
                        ? kSuccessText
                        : kWaitText,
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: kVerticalSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeSlider extends StatelessWidget {
  const _TimeSlider();

  @override
  Widget build(BuildContext context) {
    final editViewController = Get.find<EditViewController>();

    return SizedBox(
      height: 120,
      width: 120,
      child: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              strokeWidth: 8,
              value: editViewController.progressPercentage / 100,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
            Center(
              child: editViewController.isProgressCompleted
                  ? const Icon(
                      Icons.check_sharp,
                      size: kIconSize,
                    )
                  : Text(
                      '${editViewController.progressPercentage.round()}%',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
