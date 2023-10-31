// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../more_view.dart';

class _MoreItemsWidget extends StatelessWidget {
  const _MoreItemsWidget();

  @override
  Widget build(BuildContext context) {
    final moreViewController = Get.find<MoreViewController>();

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: moreViewController.getMoreItemList.length + 1,
      itemBuilder: (_, index) => index ==
              moreViewController.getMoreItemList.length
          ? nil
          : AnimatedBuilder(
              animation: moreViewController.getAnimation,
              builder: (_, child) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.2, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: moreViewController.getAnimation,
                    curve: Interval(
                      index / moreViewController.getMoreItemList.length * 0.60,
                      (index + 1) /
                          moreViewController.getMoreItemList.length *
                          0.60,
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                ),
                child: child,
              ),
              child: ListTile(
                onTap: () => moreViewController.onTapListTile(
                  index: index,
                  settings: const _SettingsBottomSheetWidget(),
                ),
                leading: Hero(
                  tag: '${HeroTag.more}$index',
                  child: SvgPicture.asset(
                    moreViewController.getMoreItemList[index].iconPath,
                    colorFilter: ColorFilter.mode(
                      context.theme.iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                title: Text(
                  moreViewController.getMoreItemList[index].title,
                  style: context.textTheme.titleSmall,
                ),
              ),
            ),
      separatorBuilder: (_, __) {
        return AnimatedBuilder(
          animation: moreViewController.getAnimation,
          builder: (_, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: moreViewController.getAnimation,
                curve: const Interval(
                  0.6,
                  1,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: child,
            );
          },
          child: const Divider(
            thickness: 1,
            height: 4,
          ),
        );
      },
    );
  }
}
