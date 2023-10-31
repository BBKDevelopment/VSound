// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../edit_view.dart';

class SettingsModalBottomSheet extends StatelessWidget {
  const SettingsModalBottomSheet({super.key});

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
                      tag: HeroTag.settings,
                      child: SvgPicture.asset(
                        kSettingsIconPath,
                        colorFilter: ColorFilter.mode(
                          context.theme.iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                        height: 10.h,
                      ),
                    ),
                    InkWell(
                      onTap: Get.back<void>,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      highlightColor: Colors.transparent,
                      child: SvgPicture.asset(
                        kCloseIconPath,
                        colorFilter: ColorFilter.mode(
                          context.theme.iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                        width: kIconSize,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kVerticalSpace),
                Text(
                  kSettingsText,
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(height: kVeryLongVerticalSpace),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kVideoSpeedText,
                          style: context.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: kLongVerticalSpace),
                        Text(
                          kVideoQualityText,
                          style: context.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(width: kHorizontalSpace),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Obx(
                            () {
                              return Slider(
                                value: editViewController.speedValue,
                                max: 7,
                                divisions: 7,
                                label: editViewController.speedValueText,
                                onChanged: editViewController.setSpeed,
                              );
                            },
                          ),
                          const SizedBox(height: kLongVerticalSpace),
                          Obx(
                            () {
                              return Slider(
                                value: editViewController.qualityValue,
                                max: 6,
                                divisions: 6,
                                label: editViewController.qualityValueText,
                                onChanged: editViewController.setQuality,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
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
