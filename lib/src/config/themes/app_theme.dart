// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vsound/src/config/config.dart';

/// [AppTheme]
///
/// Enum to keep available themes. Available themes:
/// - light
/// - dark
enum AppTheme {
  light,
  dark;

  @override
  String toString() => name;

  /// Returns [ThemeData] of the current theme.
  ThemeData get data {
    switch (this) {
      case light:
        return LightTheme().data;
      case dark:
        return DarkTheme().data;
    }
  }
}
