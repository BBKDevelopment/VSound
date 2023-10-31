// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vsound/src/core/core.dart';
import 'package:vsound/src/presentation/presentation.dart';

class NavigationBarView extends StatelessWidget {
  const NavigationBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationBarController = Get.find<NavigationBarController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.theme.dividerColor,
          ),
        ),
      ),
      child: Obx(
        () {
          return BottomNavyBar(
            selectedIndex: navigationBarController.currentIndex,
            backgroundColor: Colors.transparent,
            showElevation: false,
            onItemSelected: navigationBarController.onItemSelected,
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                activeColor: context.theme.colorScheme.secondary,
                textAlign: TextAlign.center,
                title: Text(
                  kGalleryText,
                  style: context.theme.textTheme.bodyLarge,
                ),
                icon: SvgPicture.asset(
                  kGalleryIconPath,
                  colorFilter: ColorFilter.mode(
                    context.theme.iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              BottomNavyBarItem(
                activeColor: context.theme.colorScheme.secondary,
                textAlign: TextAlign.center,
                title: Text(
                  kEditText,
                  style: context.textTheme.bodyLarge,
                ),
                icon: SvgPicture.asset(
                  kEditIconPath,
                  colorFilter: ColorFilter.mode(
                    context.theme.iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              BottomNavyBarItem(
                activeColor: context.theme.colorScheme.secondary,
                textAlign: TextAlign.center,
                title: Text(
                  kMoreText,
                  style: context.textTheme.bodyLarge,
                ),
                icon: SvgPicture.asset(
                  kMoreIconPath,
                  colorFilter: ColorFilter.mode(
                    context.theme.iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
