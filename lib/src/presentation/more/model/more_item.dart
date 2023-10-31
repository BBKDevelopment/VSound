// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'more_item.freezed.dart';

@freezed
abstract class MoreItem with _$MoreItem {
  const factory MoreItem({
    required String iconPath,
    required String title,
  }) = _MoreItem;
}
