// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../more_view.dart';

class _SettingsBottomSheetWidget extends StatelessWidget {
  const _SettingsBottomSheetWidget();

  @override
  Widget build(BuildContext context) {
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
                      tag: '${HeroTag.more}0',
                      child: SvgPicture.asset(
                        kSettingsIconPath,
                        colorFilter: ColorFilter.mode(
                          context.theme.iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                        height: context.height * 0.10,
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
                  style: context.theme.textTheme.titleMedium,
                ),
                const SizedBox(height: kVeryLongVerticalSpace),
                _buildThemeSelectionRow(context),
                const SizedBox(height: kVerticalSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSelectionRow(BuildContext context) {
    final moreViewController = Get.find<MoreViewController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          kThemeText,
          style: context.textTheme.bodyLarge,
        ),
        Obx(
          () {
            return SharpToggleSwitch(
              onTap: moreViewController.onTapThemeSwitch,
              index: moreViewController.getSelectedThemeIndex,
              left: kLightText,
              right: kDarkText,
            );
          },
        ),
      ],
    );
  }
}
