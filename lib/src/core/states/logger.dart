// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:developer';

import 'package:vsound/src/core/core.dart';

abstract class Logger {
  static void logError(Failure failure) {
    log(failure.message, name: failure.title);
  }
}
