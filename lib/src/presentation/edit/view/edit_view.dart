// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sizer/sizer.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:video_player/video_player.dart';
import 'package:vsound/src/components/components.dart';
import 'package:vsound/src/core/core.dart';
import 'package:vsound/src/presentation/presentation.dart';

part 'widgets/control_panel_widget.dart';
part 'widgets/no_sound_widget.dart';
part 'widgets/no_video_warning_widget.dart';
part 'widgets/save_modal_bottom_sheet.dart';
part 'widgets/settings_modal_bottom_sheet.dart';
part 'widgets/slide_transition_widget.dart';
part 'widgets/sound_widget.dart';
part 'widgets/video_player_widget.dart';

class EditView extends StatefulWidget {
  const EditView({super.key});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  late final EditViewController editViewController;

  @override
  void initState() {
    editViewController = Get.find();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => editViewController.resetEditPage());

    super.initState();
  }

  @override
  void dispose() {
    editViewController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: editViewController.animation,
            builder: (_, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: editViewController.animation,
                  curve: const Interval(
                    0.75,
                    1,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                kHorizontalSpace,
                kVerticalSpace,
                kHorizontalSpace,
                kVerticalSpace + kThickStrokeWidth,
              ),
              child: Obx(
                () => editViewController.isVideoReady
                    ? const _VideoPlayerWidget()
                    : const _NoVideoWarningWidget(),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: kHorizontalSpace,
            right: kHorizontalSpace,
            bottom: kVerticalSpace,
          ),
          child: _ControlPanelWidget(),
        ),
      ],
    );
  }
}
