// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../edit_view.dart';

class _ControlPanelWidget extends StatelessWidget {
  const _ControlPanelWidget();

  @override
  Widget build(BuildContext context) {
    final editViewController = Get.find<EditViewController>();

    return AnimatedBuilder(
      animation: editViewController.animation,
      builder: (_, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: editViewController.animation,
            curve: const Interval(
              0,
              1,
              curve: Curves.easeInOutCubic,
            ),
          ),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DottedBorder(
            color: context.theme.colorScheme.secondary,
            strokeWidth: kThickStrokeWidth,
            padding: EdgeInsets.zero,
            borderType: BorderType.RRect,
            dashPattern: const [6, 0],
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kVerticalSpace,
                vertical: kVerticalSpace,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: editViewController.onTapSettingsButton,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    child: AnimatedBuilder(
                      animation: editViewController.animation,
                      builder: (_, child) {
                        return _SlideTransitionWidget(
                          child,
                          beginOffset: const Offset(-5, 0),
                        );
                      },
                      child: Hero(
                        tag: HeroTag.settings,
                        child: SvgPicture.asset(
                          kSettingsIconPath,
                          colorFilter: ColorFilter.mode(
                            context.theme.iconTheme.color!,
                            BlendMode.srcIn,
                          ),
                          height: kIconSize,
                          width: kIconSize,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: editViewController.onTapSaveButton,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    child: AnimatedBuilder(
                      animation: editViewController.animation,
                      builder: (_, child) {
                        return _SlideTransitionWidget(
                          child,
                          beginOffset: const Offset(5, 0),
                        );
                      },
                      child: Hero(
                        tag: HeroTag.save,
                        child: SvgPicture.asset(
                          kSaveIconPath,
                          colorFilter: ColorFilter.mode(
                            context.theme.iconTheme.color!,
                            BlendMode.srcIn,
                          ),
                          height: kIconSize,
                          width: kIconSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DottedBorder(
            color: context.theme.colorScheme.secondary,
            padding: EdgeInsets.zero,
            borderType: BorderType.RRect,
            dashPattern: const [6, 6],
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kVerticalSpace,
                vertical: kVerticalSpace,
              ),
              child: SizedBox(
                height: 10.h,
                child: AnimatedBuilder(
                  animation: editViewController.animation,
                  builder: (_, child) {
                    return _SlideTransitionWidget(
                      child,
                      beginOffset: const Offset(2, 0),
                      prior: false,
                    );
                  },
                  child: Obx(
                    () {
                      return GridView.count(
                        crossAxisCount: 1,
                        scrollDirection: Axis.horizontal,
                        childAspectRatio: kSoundItemAspectRatio,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        controller: editViewController.autoScrollController,
                        children: List.generate(
                          editViewController.audios.isEmpty
                              ? 1
                              : editViewController.audios.length + 1,
                          (index) {
                            if (index == 0) {
                              return _NoSoundWidget(index: index - 1);
                            }

                            return _SoundWidget(index - 1);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
