// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../edit_view.dart';

class _NoVideoWarningWidget extends StatelessWidget {
  const _NoVideoWarningWidget();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            kVideoIconPath,
            colorFilter: ColorFilter.mode(
              context.theme.iconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: kLongVerticalSpace),
          Text(
            kSelectVideoTitle,
            style: context.theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kLongVerticalSpace),
          Text(
            kSelectVideoMessage,
            style: context.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      );
}
