// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/util/platform_util.dart';

///获取屏幕尺寸类型
AdaptiveWindowType get windowType =>
    getWindowType(navigatorKey.currentContext!);

///大屏幕-宽度大于1024-
bool get isDisplayDesktop => PlatformUtil.isMobile
    ? windowType >= AdaptiveWindowType.medium
    : windowType >= AdaptiveWindowType.small;

///中屏幕-宽度600-1023
bool get isDisplaySmallDesktop => PlatformUtil.isMobile
    ? windowType == AdaptiveWindowType.medium
    : windowType == AdaptiveWindowType.small;
