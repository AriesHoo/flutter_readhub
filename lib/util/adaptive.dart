// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter_readhub/main.dart';

///获取屏幕尺寸类型
AdaptiveWindowType get windowType =>
    getWindowType(navigatorKey.currentContext!);

///大屏幕-宽度大于1024-按照web布局
bool get isDisplayDesktop => windowType >= AdaptiveWindowType.medium;

///中屏幕-宽度等于1024--按照手机布局
bool get isDisplaySmallDesktop => windowType == AdaptiveWindowType.medium;
