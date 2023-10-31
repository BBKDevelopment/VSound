// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure({
    required String title,
    required String message,
    String? code,
  }) = _Failure;
}
