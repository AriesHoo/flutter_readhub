# flutter_readhub


[![](https://img.shields.io/badge/download-apk-blue.svg)](https://gitee.com/AriesHoo/flutter_readhub/raw/master/sample/sample.apk)
[![GitHub license](https://img.shields.io/github/license/AriesHoo/flutter_readhub.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![](https://img.shields.io/badge/Github-Github主仓库-blue.svg)](https://github.com/AriesHoo/flutter_readhub)
[![](https://img.shields.io/badge/Gitee-Gitee备用仓库-red.svg)](https://gitee.com/AriesHoo/flutter_readhub)

[相关文章一：用Flutter给Readhub写一个App](https://www.jianshu.com/p/5e1db7423dac)

[相关文章二：Flutter版本Readhub开源](https://www.jianshu.com/p/f4161c721ff7)

[相关文章三：Flutter iOS真机调试及打包过程记录](https://www.jianshu.com/p/58a6e272a038)

[相关文章四：Flutter iOS打包过程及构建上线审核通过流程总结](https://www.jianshu.com/p/0bba10136bf5)

[相关文章五：Freadhub终于升级Flutter2.0了](https://www.jianshu.com/p/742ca4745a51)

该项目为Flutter实战项目,为[Readhub](https://readhub.me/)非官方客户端。

数据来源于`Readhub`官方API接口。**版权及最终解释权归Readhub官方所有,如有侵权请邮箱联系删除!**

仅供学习使用，禁止商用

### 前言

> `Freadhub`是由`AriesHoo`开发维护的一个`Flutter`开源项目--`readhub`的非官方产品。

之前`Freadhub`已有`Androd`、`iOS`版本,随着`Flutter2.0`的发布`Flutter`进入了全平台`stable`时代, 经过一段时间的适配调整及屏幕适配，`MacOS`版本它终于来了`说得好像有人在期待一样😭`。

- 镇楼图 `1028*768` 默认尺寸

![](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4a823fc857a940199eee7743666500dc~tplv-k3u1fbpfcp-watermark.image)


| Fredhub | 链接 |
| --- | --- |
|  开源 Github| [flutter_readhub](https://github.com/AriesHoo/flutter_readhub) |
|  开源 Gitee| [flutter_readhub](https://gitee.com/AriesHoo/flutter_readhub) |
|  Android| [Freadhub](https://www.pgyer.com/ntMA) |
|  iOS| clone自行运行或邮箱给下设备[UUID](https://www.pgyer.com/tools/udid) |
|  MacOS| [Freadhub-聚合资讯](https://note.youdao.com/ynoteshare1/index.html?id=640fb7764ebdcbf884ccc8b2124a3db9&type=notebook#/WEB95829960b7022d52cc658ccae8d26b4e) [下载](https://note.youdao.com/yws/api/personal/file/WEB95829960b7022d52cc658ccae8d26b4e?method=download&shareKey=640fb7764ebdcbf884ccc8b2124a3db9)|

### Mac版本准备工作

#### 1、获取MacOS代码

本着`Flutter-Write Once Run Anywhere`的原则,`MacOS`版本也在`master`分支未开新分支。

- 有原始版本代码只需`Update`一下，然后`flutter pub get`一下即可。
- 没有原始代码则可在[Github](https://github.com/AriesHoo/flutter_readhub)或[Gitee](https://gitee.com/AriesHoo/flutter_readhub)上 `clone`一下，然后`flutter pub get`一下即可。


#### 2、开启MacOS支持

> 目前`Flutter 2.0 Stable`已支持`MacOS`,只需开启下`MacOS`支持即可。

- 环境：`Flutter SDK Flutter stable 2.0+`
- 开启`MacOS`支持：`flutter config --enable-macos-desktop`
- 创建`MacOS`环境配置:`flutter create --platforms=macos .`

```
 % flutter --version
Flutter 2.2.0 • channel stable • https://github.com/flutter/flutter.git
Framework • revision b22742018b (12 days ago) • 2021-05-14 19:12:57 -0700
Engine • revision a9d88a4d18
Tools • Dart 2.13.0

% flutter config --enable-macos-desktop
Setting "enable-macos-desktop" value to "true".

  % flutter create --platforms=macos .
Recreating project ....
  flutter_readhub_github.iml (created)
  macos/Runner.xcworkspace/contents.xcworkspacedata (created)
  macos/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist (created)
  macos/Flutter/Flutter-Debug.xcconfig (created)
  macos/Flutter/Flutter-Release.xcconfig (created)
  .idea/runConfigurations/main_dart.xml (created)
  .idea/libraries/KotlinJavaRuntime.xml (created)
Running "flutter pub get" in flutter_readhub_github...           1,078ms
Wrote 7 files.

All done!

```

#### 3、基础配置-icon、name、网络等

- 准备`MacOS`需要的各种尺寸icon，推荐使用 [Image Asset Icon Resizer Lite](https://apps.apple.com/cn/app/image-asset-icon-resizer-lite/id1108313046?mt=12) 可以裁剪出各种尺寸的icon、launch image --包括`Android`、`iOS`、`MacOS`等。

![生成icon](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ed11104d0e2540ffa8708fb75d73fa1d~tplv-k3u1fbpfcp-watermark.image)

将生成的icon资源及配置文件拷贝到对应文件夹即可

![macos icon配置](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f239ec141a9b4fac80b510d17336d582~tplv-k3u1fbpfcp-watermark.image)

这里推荐文件名保持和`Flutter`默认生成的一致，可在[Image Asset Icon Resizer Lite](https://apps.apple.com/cn/app/image-asset-icon-resizer-lite/id1108313046?mt=12)设置。如下图：

![设置导出flieName](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/100fcf673caa4dffa02b8491e22cdda4~tplv-k3u1fbpfcp-watermark.image)

- 设置App 信息：依次进入`macos->Runner->Configs`文件夹打开`AppInfo.xcconfig`编辑`PRODUCT_NAME`值，该值决定了App窗口标题名和程序坞鼠标悬浮提示文字以及关于页面信息；`PRODUCT_COPYRIGHT`决定了关于页面版权声明信息。如下图：

![AppInfo.xcconfig](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c0bcd6a8b8b243f8a15c7902ca51be83~tplv-k3u1fbpfcp-watermark.image)

![程序坞](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e85ac9206b764c8d9ae3b4d3e3b6a5a9~tplv-k3u1fbpfcp-watermark.image)

![关于信息](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/98ec0b27327342c9ab166b9d252e09e0~tplv-k3u1fbpfcp-watermark.image)

- 网络配置：因涉及请求接口需在`macos->Runner`文件夹下的`DebugProfile.entitlements`及`Release.entitlements`文件添加以下配置

```
    <key>com.apple.security.network.server</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <true/>
```

![网络配置](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4c955869088d446e8544c0059806a60d~tplv-k3u1fbpfcp-watermark.image)

#### 4、运行与打包

- 执行命令：`flutter run -d macos` 或直接通过 `Android Studio`选择`macOS(desktop)`运行

```
 % flutter run -d macos
Launching lib/main.dart on macOS in debug mode...
Running pod install...                                           1,956ms
```

![Android Studio运行](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/27d738afb14d4a7c9e77992f0749faec~tplv-k3u1fbpfcp-watermark.image)

- 执行命令：`flutter build macos --release`等待执行完成即可

```
% flutter build macos --release

💪 Building with sound null safety 💪

Running pod install...                                           1,709ms
``` 

- 执行完成后，在`build->macos->Build->Products->Release`文件夹里可看到打包后的应用，直接双击打开即可。

![打包后的app](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/daec0966dfff4ac3b20535c6cbedf839~tplv-k3u1fbpfcp-watermark.image)

### Freadhub MacOS功能介绍

#### 1、主界面布局

- 桌面端尺寸相较移动端更大如果采用移动端的底部/顶部tab模式会很丑，故在做`MacOS`适配过程中顺手做了下`响应式布局`--这里不做展开后期会单开文章阐述。
- 通过使用`GridView`来让屏幕展示更多可用信息
- 左侧顶部导航栏、底部为`今日诗词`推荐--使用[今日诗词](https://www.jinrishici.com/),在此感谢🙏、最底部仍然为更多信息及深色/浅色主题切换按钮

宽屏：`1280*800` 最大尺寸

![宽屏最大尺寸](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d7225e0f73f44554b076b332bb1c5123~tplv-k3u1fbpfcp-watermark.image)

窄屏：`480*640` 最小尺寸

![窄屏](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f0626347fb4541879c2d4e5db2ee96d7~tplv-k3u1fbpfcp-watermark.image)

- 这里设置widow 窗口大小用到了[desktop_window](https://pub.flutter-io.cn/packages/desktop_window)插件-支持`MacOS`、`Windows`、`Linux`；`Freadhub` 设置默认尺寸`1024*768`、最小尺寸`480*640`、最大尺寸`1280*800`。

#### 2、今日诗词

- 因屏幕尺寸过大，左侧导航栏部分只有导航tab功能会显得很空故在tab底部增加`今日诗词`功能
- 为保持适配一致性和美观性：宽屏模式显示`诗词内容+匹配标签+切歌三部分内容`；窄屏模式只显示`诗词内容`。--当然这里的美观性是个见仁见智的事情，大家轻喷。
- 增加`tooltip`功能当`鼠标悬浮或手指长按`则显示更多信息 `诗词标题+朝代作者+诗词全文+诗词翻译(如果有)`

![今日诗词tooltip](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d4a2ebf2ca1a489baf970de492e8b51f~tplv-k3u1fbpfcp-watermark.image)

#### 3、更多信息

- 布局样式和移动端一致--开源地址显示了`Github`与`Gitee`
- 分享功能与移动端有差异--移动端弹出卡片分享移动端蒲公英下载链接；桌面端的跳转网页显示`apk`及`macOS`压缩包分享页面

![更多信息](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/aa7b7db552f144018344eb371cd36830~tplv-k3u1fbpfcp-watermark.image)

![下载分享页面](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f92a7ca39666473580972c2f1f3ffce7~tplv-k3u1fbpfcp-watermark.image)

#### 4、资讯卡片

- 每个资讯卡片背景样式优化-增加`边框线`区分不同资讯、`鼠标悬浮/手指按下边界线及背景变为主题色相关色`

![悬浮边框色变化](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d5ed182ee722424ca16d0eee44addbac~tplv-k3u1fbpfcp-watermark.image)

- 修改点击事件-将原来点击事件`资讯摘要信息全部展示`变更为`打开查看资讯详情`

![查看详情](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/98a6657ccd14403ca43fc6d9b1a02c61~tplv-k3u1fbpfcp-watermark.image)

该功能使用到了[flutter_macos_webview](https://pub.flutter-io.cn/packages/flutter_macos_webview)插件

- 去掉热门话题`相关推荐icon`变更为`分享icon`-原长按弹出分享卡片不变、`热门话题详情直接跳转readhub网页详情`

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/48824b1aa3b6440097d9d3b55b9940f3~tplv-k3u1fbpfcp-watermark.image)

该功能使用到了[share_plus](https://pub.flutter-io.cn/packages/share_plus)插件

#### 5、其它功能

啥也不说了，都在代码里了，
 [Github](https://github.com/AriesHoo/flutter_readhub)、 [Gitee](https://gitee.com/AriesHoo/flutter_readhub)。欢迎`拍砖` `扔鸡蛋`。

### 总结

1、就着这次适配`MacOS`过程，鄙人感觉`Flutter`确实很香！在`UI`层面确实在各个平台上的复用率在90%以上。但是确实需要根据不同的平台特性做调整：如在桌面系统使用移动端的顶部/底部导航就很别扭。

2、 平台相关插件除开移动端的其它平台确实要走的路还很漫长。--所以未来会有`插件工程师`这个专门工种？

3、桌面系统能多窗口就更好了。--`Android`是单`Activity`的模式的，`iOS`也是类似的。这种模式在移动端的没啥问题，毕竟设备就那么大点。但是桌面系统普遍较大,所有页面跳转都在同一个窗口就感觉差点意思。`也许是支持的只是我不知道？`--有知道的大佬万望不吝赐教，感谢🙏！

4、`Flutter`仍然是未来跨平台的最佳选择 `没有之一`

### 结语

该App为笔者学习`Flutter`练手开发的 ，权当抛砖引玉了，万望各位不吝赐教

###  关于我

掘金: [AriesHoo](https://juejin.im/user/57c3cdcb5bbb50006341a6a4) 

简书: [AriesHoo](http://www.jianshu.com/u/a229eee96115)

GitHub: [AriesHoo](https://github.com/AriesHoo)

Email: AriesHoo@126.com

## License

```
Copyright 2019-2021 Aries Hoo

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
