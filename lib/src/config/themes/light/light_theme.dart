// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// {@template light_theme}
/// [LightTheme] Class
/// {@endtemplate}
class LightTheme {
  /// {@macro light_theme}
  factory LightTheme() => _lightTheme;

  LightTheme._();

  static final LightTheme _lightTheme = LightTheme._();

  /// ThemeData of LightData
  final ThemeData data = ThemeData(
    // Material3 causes video selection bug.
    // useMaterial3: true,
    fontFamily: 'RobotoMono',
    primaryColor: const Color(0xFFF8F3F7),
    primaryColorDark: const Color(0xFFF8F3F7),
    primaryColorLight: const Color(0xFF181818),
    scaffoldBackgroundColor: const Color(0xFFF8F3F7),
    cardColor: const Color(0xFFF8F3F7),
    indicatorColor: const Color(0xB3181818),
    focusColor: const Color(0x66F8F3F7),
    dividerColor: const Color(0x80181818),
    splashColor: const Color(0x33181818),
    iconTheme: const IconThemeData(color: Color(0xFF181818)),
    appBarTheme: const AppBarTheme(color: Color(0xFFF8F3F7)),
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFF181818),
      inactiveTrackColor: const Color(0xFF181818),
      thumbColor: const Color(0xFF181818),
      activeTickMarkColor: const Color(0xFF181818),
      inactiveTickMarkColor: const Color(0xFF181818),
      valueIndicatorColor: const Color(0xFF181818),
      overlayColor: const Color(0x33181818),
      trackShape: const RectangularSliderTrackShape(),
      thumbShape: const RoundSliderThumbShape(),
      tickMarkShape: const RoundSliderTickMarkShape(),
      valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
      valueIndicatorTextStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFF8F3F7),
      ),
      trackHeight: 2,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        ),
        side: MaterialStateProperty.all(
          const BorderSide(color: Color(0xFF181818)),
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
      bodyColor: const Color(0xFF181818),
      displayColor: const Color(0xFF181818),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: const Color(0xFFF8F3F7),
      // Sliding color
      secondary: const Color(0xFF181818),
      background: const Color(0xFFF8F3F7),
    ),
  );
}
