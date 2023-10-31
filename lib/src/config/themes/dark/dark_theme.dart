// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// {@template dark_theme}
/// [DarkTheme] Class
/// {@endtemplate}
class DarkTheme {
  /// {@macro dark_theme}
  factory DarkTheme() => _darkTheme;

  DarkTheme._();

  static final DarkTheme _darkTheme = DarkTheme._();

  /// ThemeData of DarkTheme
  final ThemeData data = ThemeData(
    // Material3 causes video selection bug.
    // useMaterial3: true,
    fontFamily: 'RobotoMono',
    primaryColor: const Color(0xFF181818),
    primaryColorDark: const Color(0xFF181818),
    primaryColorLight: const Color(0xFFF8F3F7),
    scaffoldBackgroundColor: const Color(0xFF181818),
    cardColor: const Color(0xFF181818),
    indicatorColor: const Color(0xB3F8F3F7),
    focusColor: const Color(0x66181818),
    dividerColor: const Color(0x33F8F3F7),
    splashColor: const Color(0x33F8F3F7),
    iconTheme: const IconThemeData(color: Color(0xFFF8F3F7)),
    appBarTheme: const AppBarTheme(color: Color(0xFF181818)),
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFFF8F3F7),
      inactiveTrackColor: const Color(0xFFF8F3F7),
      thumbColor: const Color(0xFFF8F3F7),
      activeTickMarkColor: const Color(0xFFF8F3F7),
      inactiveTickMarkColor: const Color(0xFFF8F3F7),
      valueIndicatorColor: const Color(0xFFF8F3F7),
      overlayColor: const Color(0x33F8F3F7),
      trackShape: const RectangularSliderTrackShape(),
      thumbShape: const RoundSliderThumbShape(),
      tickMarkShape: const RoundSliderTickMarkShape(),
      valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
      valueIndicatorTextStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF181818),
      ),
      trackHeight: 2,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        ),
        side: MaterialStateProperty.all(
          const BorderSide(color: Color(0xFFF8F3F7)),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.w700,
      ),
      bodySmall: TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.w400,
      ),
    ).apply(
      bodyColor: const Color(0xFFF8F3F7),
      displayColor: const Color(0xFFF8F3F7),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: const Color(0xFF181818),
      // Sliding color
      secondary: const Color(0xFFF8F3F7),
      background: const Color(0xFF181818),
    ),
  );
}
