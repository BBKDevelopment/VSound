// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../select_view.dart';

class _RequestPermissionWidget extends StatelessWidget {
  const _RequestPermissionWidget();

  @override
  Widget build(BuildContext context) {
    final selectViewController = Get.find<SelectViewController>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kHorizontalSpace,
        vertical: kVerticalSpace,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            kAccessIconPath,
            colorFilter: ColorFilter.mode(
              context.theme.iconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: kLongVerticalSpace),
          Text(
            kCantSelectVideoTitle,
            style: context.theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kLongVerticalSpace),
          Text(
            kRequestPermissionMessage,
            style: context.theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kVerticalSpace),
          Text(
            kPermissionPathInAndroidText,
            style: context.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kLongVerticalSpace),
          OutlinedButton(
            onPressed: selectViewController.onTapOpenSettings,
            child: Text(
              kOpenSettingsText,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
