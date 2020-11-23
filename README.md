# flutter_readhub


[![](https://img.shields.io/badge/download-apk-blue.svg)](https://gitee.com/AriesHoo/flutter_readhub/raw/master/sample/sample.apk)
[![GitHub license](https://img.shields.io/github/license/AriesHoo/flutter_readhub.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![](https://img.shields.io/badge/Github-Github主仓库-blue.svg)](https://github.com/AriesHoo/flutter_readhub)
[![](https://img.shields.io/badge/Gitee-Gitee备用仓库-red.svg)](https://gitee.com/AriesHoo/flutter_readhub)

[相关文章一：用Flutter给Readhub写一个App](https://www.jianshu.com/p/5e1db7423dac)

[相关文章二：Flutter版本Readhub开源](https://www.jianshu.com/p/f4161c721ff7)

[相关文章三：Flutter iOS真机调试及打包过程记录](https://www.jianshu.com/p/58a6e272a038)

该项目为Flutter实战项目,为[Readhub](https://readhub.me/)非官方客户端。

数据来源于Readhub官方API接口。**版权及最终解释权归Readhub官方所有,如有侵权请邮箱联系删除!**

仅供学习使用，禁止商用

## 前言

说来惭愧，去年开始学习Flutter开发时用网上的Api给Readhub开发了个Flutter版App，五个月前(2020-6-26)整理了下发了一篇文章[用Flutter给Readhub写一个App](https://www.jianshu.com/p/5e1db7423dac)，当时准备说再整理下源码给开源下,没想到一拖就5个月过去了。我这拖延症。

最近将源码整理了下,升级了下SDK及各个三方库。并用测试证书打包了一个iOS测试版发布到蒲公英。

[GitHub地址](https://github.com/AriesHoo/flutter_readhub)     [Gitee地址](https://gitee.com/AriesHoo/flutter_readhub)

![扫码下载](https://www.pgyer.com/app/qrcode/ntMA)

说明：

1、该二维码为Android iOS通用,蒲公英会根据手机自动重定向。

2、iOS版本只加了21台周围的朋友UUID,如果有朋友想要下载尝试可将UUID留言到GitHub或者私信到我的邮箱，我会第一时间打包并通知你，感谢

![扫码获取UUID](https://www.pgyer.com/qrCodePNG/generateQR?content=https://www.pgyer.com/tools/udid)

因为前面文章介绍了不少的页面及实现功能相关描述，这里只简要介绍下项目的分包及使用的三方库及当前环境。

## 效果一览

###  Android 部分

浅色主题 | 深色主题 | 
-|-
![](https://upload-images.jianshu.io/upload_images/2828782-b0f264ff8130888b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)| ![](https://upload-images.jianshu.io/upload_images/2828782-fab837fbe5964914.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
资讯详情| 更多操作 | 
| ![](https://upload-images.jianshu.io/upload_images/2828782-945aa151bb9f6b3d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)| ![](https://upload-images.jianshu.io/upload_images/2828782-e3ee8a2252aede6b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
 | 选择主题 | 社交分享 |
 ![](https://upload-images.jianshu.io/upload_images/2828782-a87eaa05e71f37e5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)| ![](https://upload-images.jianshu.io/upload_images/2828782-ce917d37671b1367.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

###  iOS 部分

浅色主题 | 深色主题 | 
-|-
![](https://upload-images.jianshu.io/upload_images/2828782-d32c592c48194dd6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)| ![](https://upload-images.jianshu.io/upload_images/2828782-5f54608101d4618e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
资讯详情| 更多操作 | 
| ![](https://upload-images.jianshu.io/upload_images/2828782-7e5b92c094bc2048.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)| ![](https://upload-images.jianshu.io/upload_images/2828782-cd50e71517e32765.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
 | 选择主题 | 社交分享 |
 ![](https://upload-images.jianshu.io/upload_images/2828782-7189161f93d57a60.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)|![](https://upload-images.jianshu.io/upload_images/2828782-941060caeccc5e48.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

## 分包

![](https://upload-images.jianshu.io/upload_images/2828782-e2835295e6a943c1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/720)

![分包结构](https://upload-images.jianshu.io/upload_images/2828782-07cff1e254e006f2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/720)


basis：主要存放一些基类

data：为api调用相关-文章及更新app

dialog：为用户信息及分享dialog弹窗-继承Dialog

generated及l10n：为国际化插件自动生成

helper：为路径及权限等帮助类

model：存放数据对象

page：页面

util：各种工具栏

view_model：为page与data之前桥梁

widget：为拆分公共组件

## 三方库

~~~
  #  国际化支持
  flutter_localizations:
    sdk: flutter
  # 状态管理State
  provider: ^4.3.2
  #  吐司toast
  oktoast: ^2.2.0
  #  设备信息
  device_info: ^0.4.2+4
  #  应用包信息
  package_info: ^0.4.1

  # WebView
  webview_flutter: ^0.3.22+1
  #  网络请求相关dio
  dio: ^3.0.9
  #  加载网络图片
  cached_network_image: ^2.2.0+1
  synchronized: ^2.1.0+1
  #  下拉刷新
  pull_to_refresh: ^1.6.0
  #  本地缓存sp
  shared_preferences: ^0.5.7+3
  #用于做骨架屏-闪光效果
  shimmer: ^1.1.1
  #跳转系统浏览器/打电话等
  url_launcher: ^5.4.11
  #二维码-生成
  qr_flutter: ^3.2.0
  #工具类
  flustars: ^0.3.2
  #动态权限申请
  permission_handler: ^5.0.1
  #文件路径
  path_provider: ^1.6.11
  #分享文字及文件-注意保存文件位置
  #注意0.1.2以后的版本分享图片微信提示获取资源失败，分享到其它平台正常
  flutter_share_plugin: 0.1.2
~~~

## 本地运行环境

~~~
[✓] Flutter (Channel stable, 1.20.0, on macOS 11.0.1 20B29, locale zh-Hans-CN)
    • Flutter version 1.20.0 at /Users/scta/develop/Flutter/SDK/flutter
    • Framework revision 840c9205b3 (3 months ago), 2020-08-04 20:55:12 -0700
    • Engine revision c8e3b94853
    • Dart version 2.9.0
    • Pub download mirror https://pub.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn

[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.3)
    • Android SDK at /Users/scta/Library/Android/sdk
    • Platform android-29, build-tools 29.0.3
    • ANDROID_HOME = /Users/scta/Library/Android/sdk
    • Java binary at: /Applications/Android Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6915495)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 12.2)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 12.2, Build version 12B45b
    • CocoaPods version 1.9.3

[!] Android Studio (version 4.1)
    • Android Studio at /Applications/Android Studio.app/Contents
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
    ✗ Dart plugin not installed; this adds Dart specific functionality.
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6915495)

[✓] IntelliJ IDEA Ultimate Edition (version 2020.1)
    • IntelliJ at /Applications/IntelliJ IDEA.app
    • Flutter plugin version 46.0.3
    • Dart plugin version 201.7223.43

[✓] Connected device (2 available)
    • Android SDK built for x86 (mobile) • emulator-5554                        • android-x86 • Android 10 (API 29) (emulator)
    • iPhone 8 (mobile)                  • B3F143F6-7BCE-41D4-9FBC-75163AE84EE9 • ios         • com.apple.CoreSimulator.SimRuntime.iOS-14-2 (simulator)

! Doctor found issues in 1 category.
Process finished with exit code 0
~~~

原则上任意环境都能正常运行

## 注意事项

1、笔者已将国际化生成为文件夹都上传了如果发现有相关国际化内容显示异常可安装插件Flutter Intl

![Flutter Intl](https://upload-images.jianshu.io/upload_images/2828782-e91e0ad92783136b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/720)

## 结语

该App为笔者学习Flutter练手开发的 ，权当抛砖引玉了，万望各位不吝赐教

##  关于我

掘金: [AriesHoo](https://juejin.im/user/57c3cdcb5bbb50006341a6a4) 

简书: [AriesHoo](http://www.jianshu.com/u/a229eee96115)

GitHub: [AriesHoo](https://github.com/AriesHoo)

Email: AriesHoo@126.com

## License

```
Copyright 2019-2020 Aries Hoo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

```
