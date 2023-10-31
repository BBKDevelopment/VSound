// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nil/nil.dart';
import 'package:vsound/src/components/components.dart';
import 'package:vsound/src/core/core.dart';
import 'package:vsound/src/presentation/presentation.dart';

part 'widgets/copyright_widget.dart';
part 'widgets/more_items_widget.dart';
part 'widgets/settings_bottom_sheet_widget.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kHorizontalSpace,
        vertical: kVerticalSpace,
      ),
      child: Column(
        children: [
          Expanded(
            child: _MoreItemsWidget(),
          ),
          _CopyrightWidget(),
        ],
      ),
    );
  }
}
