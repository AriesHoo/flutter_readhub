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

## 前言

Flutter 在 `2021.03.04` 发布了 `Flutter 2.0`版本 正式进入 `全平台Stable时代` 具体可见

[【译】Flutter 2.0 正式版发布，全平台 Stable](https://juejin.cn/post/6935621027116531720)  

[【译】Flutter 2 正式版的新功能，一睹为快](https://juejin.cn/post/6935642154853203982)

[Flutter 升级 2.0 填坑指导，带你原地起飞](https://juejin.cn/post/6938342360833064974)

`Freadhub`没有第一时间升级,但是也在`4月`进行了`Flutter 2.0`及`空安全`的升级并在 `2021-04-12` 发布了 `1.2.4`版本,后期陆陆续续做了一些小调整，直到最近 公司的项目做了个卡片分享的功能，效果还不错就同步移植，在此做一个简单的记录。---当前最新版本`1.2.6`

![扫码下载](https://upload-images.jianshu.io/upload_images/2828782-7e167a7701fa7497.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/720)

注:还是只支持Android手机下载，iOS请自行下载运行。

[开源地址-flutter_readhub](https://github.com/AriesHoo/flutter_readhub)

## 升级Flutter2.0

大家都知道执行`flutter upgrade` 或者 `Tools --> Flutter --> Flutter Upgrade`即可升级`Flutter`到最新版本。

![Flutter升级](https://upload-images.jianshu.io/upload_images/2828782-7265e2ed349aab89.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/720)

但是在升级前还是建议copy 一份 以免出现意外情况--当然还有其它方式可以复原，自己习惯的即可。

## 迁移空安全

[官网文档](https://dart.dev/null-safety/unsound-null-safety)、[中文文档](https://dart.cn/null-safety/migration-guide) ，`空安全` 迁移大概有下面几个步骤：

1、  执行`flutter pub outdated --mode=null-safety` ，检查自己项目依赖的库是否都支持空安全

比较给力的是`Freadhub`所用到的三方库大多都已升级了`空安全`版本，唯一不支持的分享插件`flutter_share_plugin`已使用官网分享库 `share`替换 😂--大家在升级过程中也可尝试。如果是使用频度较高的库，大概率会很快升级的。不然就找下替代库即可。

全支持会出现 `All your dependencies declare support for null-safety.` 提示

![全部支持空安全](https://upload-images.jianshu.io/upload_images/2828782-1b1b2d2c8cbb6720.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/720)

![有不支持空安全](https://upload-images.jianshu.io/upload_images/2828782-c3549641484b94d4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/720)

如果还有不支持`空安全`的库--那就再等等。因为自己下载下来修改成本太高，且后期维护成本也不小。

2.、 如果都支持了，执行 `dart migrate --apply-changes`。执行完毕之后，你的 `Dart SDK` 版本会自动改为大于`2.12.0`。

**注意：执行 dart migrate 命令必须确保 `SDK` 是小于 `2.12.0` 的；
           不加 `--apply-changes` 的话，会有一个浏览器地址，打开之后，可以在浏览器中进行修改**

3 、工具执行完成一定会有一些 `错误`，根据自己的业务场景对代码进行更正。

## 使用官方分享库

前文提到：`Freadhub`之前版本使用的分享插件为`flutter_share_plugin`，遗憾的是该库未升级  `空安全`支持。故使用官方分享插件`share`替换。  
其实之前使用`flutter_share_plugin`的原因在于官方的`share`插件功能太单一了只支持分享文本不支持分享文件。如今官方插件支持分享文件且支持`空安全`换回来何乐不为。---`0.6.5`版本开始增加分享文件功能

## 丰富分享效果

之前版本`Freadhub`只支持列表长按分享卡片模式，且不支持分享指定App(常见的QQ、微信、微博等)

![之前版本分享功能](https://upload-images.jianshu.io/upload_images/2828782-7c5ddf57a9fcd556.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/720)

最新版本支持:资讯详情页分享文本链接到`微信好友`、`QQ`、`微博`、`钉钉`、`企业微信`、`复制链接`、`浏览器打开`、`更多`。

![资讯详情分享文本链接- Android](https://upload-images.jianshu.io/upload_images/2828782-3948f1cd5a7f470d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/360)

![资讯详情分享文本链接- iOS](https://upload-images.jianshu.io/upload_images/2828782-d04dc6c879f4c3f8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/360)

最新版本：资讯列表及资讯详情分享页支持卡片(图片)分享到`微信好友`、`朋友圈`、`QQ`、`微博`、`钉钉`、`企业微信`、`更多`等。--且内置`Freadhub卡片`样式及`掘金卡片`样式两种效果选择

![Freadhub卡片样式- Android](https://upload-images.jianshu.io/upload_images/2828782-7a143c81ed39b754.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/360)

![掘金卡片样式- Android](https://upload-images.jianshu.io/upload_images/2828782-9b407ffd062f2f32.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/360)

![掘金卡片样式- iOS](https://upload-images.jianshu.io/upload_images/2828782-a3bf37556e47fc26.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/360)

注：该功能涉及修改  `share`插件-版本`2.0.1`当前最新版，且只修改了`Android`部分，`iOS`未找到相应实现方式，且网上实现方式均是`2017年`左右代码，拷贝运行未调起相关App。--如有大佬知道`iOS`如何使用系统自带分享功能指定App的麻烦不吝赐教，感谢🙏！

## Android只支持64位cpu

`Freadhub`最初版本Android设置  `armeabi-v7a`这样可支持市场绝大多数32及64位cpu手机。现在最新版本`1.2.6` 设置`arm64-v8a` 即:只支持64位cpu手机

## 其它小优化

1、全局增大圆角效果原先的6增大到12-包括`AlertDialog`、更多信息`Dialog`、底部`ModalBottomSheet`、卡片圆角线及`Card`、选择主题`Button`圆角

2、优化选择主题方式-将原来的折叠形式改为底部弹出`ModalBottomSheet`模式

3、修改toast组件`oktoast`为`bot_toast`，并修改`ToastUtitl`默认使用悬浮通知卡片模式

4、去除文本段前段后的空白字符，优化显示更多资讯逻辑。

5、资讯详情页增加底部分享`FloatingActionButton`，方便单手操作

## 当前版本运行环境

使用三方库
~~~
environment:
  sdk: '>=2.12.0 <3.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.3
  #  国际化支持
  flutter_localizations:
    sdk: flutter
  # 状态管理State
  provider: ^5.0.0
  #  吐司toast
  bot_toast: ^4.0.1
  #  设备信息
  device_info: ^2.0.0
  #  应用包信息
  package_info: ^2.0.0

  # WebView
  webview_flutter: ^2.0.4
  #  网络请求相关dio
  dio: ^4.0.0
  #  加载网络图片
  cached_network_image: ^3.0.0
  synchronized: ^3.0.0
  #  下拉刷新
  pull_to_refresh: ^2.0.0
  #  本地缓存sp
  shared_preferences: ^2.0.5
  #用于做骨架屏-闪光效果
  shimmer: ^2.0.0
  #跳转系统浏览器/打电话等
  url_launcher: ^6.0.3
  #二维码-生成
  qr_flutter: ^4.0.0
  #工具类
  flustars: ^2.0.1
  #动态权限申请
  permission_handler: ^7.1.0
  #文件路径
  path_provider: ^2.0.1
  #分享文字及文件-注意保存文件位置
  #注意0.1.2以后的版本分享图片微信提示获取资源失败，分享到其它平台正常
#  flutter_share_plugin: 0.1.2
#  share: ^2.0.1
  # 使用官网分支增加分享特定App/App某个方法 增加判断App是否安装方法-Android
  # 参考官网 https://flutter.dev/docs/development/packages-and-plugins/using-packages
  share:
    git:
      url: git://github.com/AriesHoo/plugins.git
      path: packages/share
      ref: change_share
      version: 2.0.1
~~~

运行环境

~~~
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 2.0.6, on macOS 11.3.1 20E241 darwin-x64, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 30.0.3)
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] Android Studio (version 4.2)
[✓] IntelliJ IDEA Ultimate Edition (version 2020.3.3)
[✓] Connected device (2 available)

• No issues found!
~~~

## 主要功能一览

浅色主题 | 深色主题 | 
-|-
![](https://upload-images.jianshu.io/upload_images/2828782-7b7e4e4c6017d4b1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600) | ![](https://upload-images.jianshu.io/upload_images/2828782-7211bc2f36087cf8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
资讯详情| 分享链接 | 
![](https://upload-images.jianshu.io/upload_images/2828782-8ebce6e97ff6f9c4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)| ![](https://upload-images.jianshu.io/upload_images/2828782-bb77d494acdb9f11.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
Freadhub卡片| Freadhub卡片-深色模式 | 
![](https://upload-images.jianshu.io/upload_images/2828782-667fb8e39808d361.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)|![](https://upload-images.jianshu.io/upload_images/2828782-26187dca03c52476.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
掘金样式卡片| 掘金样式卡片-深色模式 | 
![](https://upload-images.jianshu.io/upload_images/2828782-5eda6647ac4965ec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)|![](https://upload-images.jianshu.io/upload_images/2828782-10533e51a9299a8b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
分享微博效果| 分享邮箱效果 | 
![](https://upload-images.jianshu.io/upload_images/2828782-eb7e0793afee3761.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)|![](https://upload-images.jianshu.io/upload_images/2828782-ceef288901523bc0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
更多资讯来源| 应用设置 | 
![](https://upload-images.jianshu.io/upload_images/2828782-868445477b2ab804.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)|![](https://upload-images.jianshu.io/upload_images/2828782-45f6c95c2873fe86.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
选择主题| 快速回到顶部 | 
![](https://upload-images.jianshu.io/upload_images/2828782-3f7d270d1ff2df9b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)|![](https://upload-images.jianshu.io/upload_images/2828782-a7b1968ba28afdc4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

## 结语

该App为笔者学习`Flutter`练手开发的 ，权当抛砖引玉了，万望各位不吝赐教

##  关于我

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
