// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

/// [AnimationDuration] Class
///
/// This class can not be initialized.
///
/// It contains constant various animation
/// durations. All fields are static and directly
/// accessible.
abstract class AnimationDuration {
  /// [homePageIn] animation duration.
  ///
  /// Default value:
  ///
  /// ```dart
  /// Duration(milliseconds: 600)
  /// ```
  static const homePageIn = Duration(milliseconds: 600);

  /// [homePageOut] animation duration.
  ///
  /// Default value:
  ///
  /// ```dart
  /// Duration(milliseconds: 300)
  /// ```
  static const homePageOut = Duration(milliseconds: 300);

  /// [editPageIn] animation duration.
  ///
  /// Default value:
  ///
  /// ```dart
  /// Duration(milliseconds: 800)
  /// ```
  static const editPageIn = Duration(milliseconds: 800);

  /// [editPageOut] animation duration.
  ///
  /// Default value:
  ///
  /// ```dart
  /// Duration(milliseconds: 300)
  /// ```
  static const editPageOut = Duration(milliseconds: 300);

  /// [morePageIn] animation duration.
  ///
  /// Default value:
  ///
  /// ```dart
  /// Duration(milliseconds: 1000)
  /// ```
  static const morePageIn = Duration(milliseconds: 1000);

  /// [morePageOut] animation duration.
  ///
  /// Default value:
  ///
  /// ```dart
  /// Duration(milliseconds: 300)
  /// ```
  static const morePageOut = Duration(milliseconds: 300);
}
