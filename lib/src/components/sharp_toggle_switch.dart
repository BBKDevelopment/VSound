// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

class SharpToggleSwitch extends StatelessWidget {
  const SharpToggleSwitch({
    required this.onTap,
    required this.index,
    required this.left,
    required this.right,
    super.key,
  });

  final void Function(int index) onTap;
  final int index;
  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 140,
      decoration: BoxDecoration(
        border: Border.all(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Theme.of(context).primaryColorLight
              : Theme.of(context).primaryColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: index == 0
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    left,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: index == 1
                              ? Theme.of(context).primaryColorLight
                              : Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: index == 1
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    right,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: index == 1
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColorLight,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
