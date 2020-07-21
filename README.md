# flutter_readhub

该项目为Flutter实战项目,为[Readhub](https://readhub.me/)非官方客户端。

数据来源于Readhub官方API接口。**版权及最终解释权归Readhub官方所有,如有侵权请邮箱联系删除!**

仅供学习使用，禁止商用

>- **[【 简书】](https://www.jianshu.com/p/5e1db7423dac)**
>- **[【 掘金】](https://juejin.im/post/5ef5bb1fe51d4534bb148c67)**

## 前言

学习Flutter也有一段时间了，这个项目是当时学习过程做的一个练手项目（2019年11月10日）边做边学大概用了半个月的时间完成，至于为啥到现在才写这篇文章。这是一个伤心💔的故事，还不是因为穷买不起Mac😂，没有做iOS的适配检测。感觉没有做过iOS适配检测的Flutter项目是不完整的，故这个项目一直就拖在那里了。时隔8个月终于可以做iOS适配检测了（**当然还是不是自己的Mac，公司给配的，为公司点赞👍**），故将这个项目的历程做一个阶段性的总结。

## 项目简介

名称：**Freadhub** ：即Flutter版本的readhub。[readhub官网](https://www.readhub.cn/)

logo：**字母F(Flutter)+字母R(readhub) 结合蓝色背景**-灵(chao)感(xi)来自阿里巴巴Flutter开源项目[**FlutterGo**]([https://github.com/alibaba/flutter-go](https://github.com/alibaba/flutter-go)
)的logo

![Freadhub](https://upload-images.jianshu.io/upload_images/2828782-400c882f7c2b8013.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

slogan：**Freadhub-做轻便的聚合资讯**

![slogan](https://upload-images.jianshu.io/upload_images/2828782-2b3f944f4f0dac93.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

iOS: 没有😼(什么没有iOS下载地址，那你检测个什么iOS适配😂)

Android下载地址：[蒲公英下载-安装密码1](https://www.pgyer.com/ntMA)

![蒲公英下载-安装密码1](https://upload-images.jianshu.io/upload_images/2828782-ecc226516c58965e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 主要功能

Freadhub 主要囊括以下功能：
**热门话题**、**科技动态**、**开发者**、**区块链**四大模块
相关聚合资讯快捷查看
方便快捷的浅色/深色模式切换
丰富的彩虹颜色主题/每日主题切换
长按社会化分享预览图效果模式
方便快捷的意见反馈入口

浅色主题 | 深色主题 | 
-|-
![](https://upload-images.jianshu.io/upload_images/2828782-3ff1edcb6ebb2d1a.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)  | ![](https://upload-images.jianshu.io/upload_images/2828782-ad56708cf1abda96.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600) 
资讯详情| 更多操作 | 
| ![](https://upload-images.jianshu.io/upload_images/2828782-adeee853d0acb8dc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)| ![](https://upload-images.jianshu.io/upload_images/2828782-ab5cee42e37dc09a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
 | 选择主题 | 社交分享 |
 ![](https://upload-images.jianshu.io/upload_images/2828782-cd035d26c531bf6f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)| ![](https://upload-images.jianshu.io/upload_images/2828782-0b27841d2d8b082b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)|

## 主要功能实现

该项目主要使用`dio`库进行网络请求，`provider`进行状态管理；比较精巧及轻便本身功能比较少但实用。这里挑选几个主要功能实现来简要概述下。

### 七色彩虹主题切换及深色模式-Android虚拟导航栏颜色

**深色模式**：Flutter提供了方便的浅色/深色主题自动切换相关入口：`MaterialApp`下的`theme`及`darkTheme`入口用于设置`ThemeData`用于控制几乎所有的Widget颜色及主题；Flutter会根据系统`（iOS 13及以上版本、Android 10及以上版本原生支持深色模式）`当前主题设置自动调用对应theme或darkTheme设置的ThemeData属性进行Widget主题切换操作。该部分可参考 [Flutter适配深色模式（DarkMode）](https://www.jianshu.com/p/76539f98b146)

**主动切换颜色主题及深色主题**：Freadhub提供了**自动切换深色/浅色主题**（如果系统设置了深色模式优先）及 七色彩虹系颜色主题设置（icon及部分文字颜色及tab下划线）可选择固定的颜色也可选择每天顺序变化。主要流程则是创建一个`ThemeViewModel`类继承`ChangeNotifier`（以便在选择`Color`值后调用notifyListeners进行widget刷新）->选择对应的主题颜色值 ->调用`ThemeViewModel `的`notifyListeners`方法通知widget刷新 

1、入口widget设置`MaterialApp`下的`theme`及`darkTheme`对应的`ThemeData`来自`ThemeViewModel`方法返回。主要代码如下：
~~~
@override
  Widget build(BuildContext context) {
    return BasisProviderWidget2<ThemeViewModel, LocaleViewModel>(
      model1: ThemeViewModel(),
      model2: LocaleViewModel(),
      builder: (context, theme, locale, child) => MaterialApp(
        ///全局主题配置
        theme: theme.themeData(),
        ///全局配置深色主题
        darkTheme: theme.themeData(platformDarkMode: true)，
        ///国际化语言
        locale: locale.locale,
        localizationsDelegates: [
          S.delegate,
          ///下拉刷新库国际化配置
          RefreshLocalizations.delegate,
          ///不配置该项会在EditField点击弹出复制粘贴工具时抛异常 The getter 'cutButtonLabel' was called on null.
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        ///启动页显示slogan
        home: SplashPage(),
      ),
    );
~~~

2、`ThemeViewModel`获取`ThemeData`方法主要代码

~~~
///根据主题 明暗 和 颜色 生成对应的主题[dark]系统的Dark Mode
themeData({bool platformDarkMode: false}) {
    var isDark = platformDarkMode || _userDarkMode;
    var themeColor = _themeColor;
    _accentColor = isDark ? themeColor[600] : _themeColor;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;
    var themeData = ThemeData(
      ///主题浅色或深色
      brightness: brightness,
      primaryColorBrightness: brightness,
      accentColorBrightness: brightness,
      primarySwatch: themeColor,
      ///强调色
      accentColor: accentColor,
      primaryColor: accentColor,
    );
    themeData = themeData.copyWith(
        ///appBar主题
      appBarTheme: themeData.appBarTheme.copyWith(
        ///根据主题设置Appbar样式背景
        color: isDark ? colorBlackTheme : Colors.white,
        ///去掉海拔高度
        elevation: 0,
        ///文本样式
        textTheme: TextTheme(
          ///title Text样式
          subtitle1: TextStyle(
            color: isDark ? Colors.white : accentColor,
            fontSize:17,
            fontWeight: FontWeight.w500,
            ///字体
            fontFamily: fontValueList[_fontIndex],
          ),
          ///action Text样式
          bodyText2: TextStyle(
            color: isDark ? Colors.white : accentColor,
            fontSize:13,
            fontWeight: FontWeight.w500,
            ///字体
            fontFamily: fontValueList[_fontIndex],
          ),
        ),
        ///icon样式
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : accentColor,
        ),
      ),
      ///全局icon
      iconTheme: themeData.iconTheme.copyWith(
        color: accentColor,
      ),
      ///长按提示文本样式
      tooltipTheme: themeData.tooltipTheme.copyWith(
          textStyle: TextStyle(
              fontSize: 13,
              color:
                  (darkMode ? Colors.black : Colors.white).withOpacity(0.9))),
      ///TabBar样式设置
      tabBarTheme: themeData.tabBarTheme.copyWith(
        ///标签内边距
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
        ///选中label样式
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        ///未选中label样式
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,
        ),
      ),
      ///floatingActionButton样式
      floatingActionButtonTheme: themeData.floatingActionButtonTheme.copyWith(
        ///背景色
        backgroundColor: themeAccentColor,
        ///水波纹颜色
        splashColor: themeColor.withAlpha(50),
      ),
    );
    setSystemBarTheme();
    return themeData;
  }
~~~

**3、选择Color主题,通知主widget更新**

~~~
/// 切换指定色彩；没有传[brightness]就不改变brightness,color同理
  void switchTheme(
      {bool userDarkMode, int themeIndex, MaterialColor color}) async {
    if (themeIndex != null && themeIndex != _themeIndex) {
      SpUtil.putInt(SP_KEY_THEME_COLOR_INDEX, themeIndex);
    }
    _userDarkMode = userDarkMode ?? _userDarkMode;
    _themeIndex = themeIndex ?? _themeIndex;
    _themeColor = color ?? getThemeColor();
    ///存入缓存
    SpUtil.putBool(SP_KEY_THEME_DARK_MODE, _userDarkMode);
    notifyListeners();
  }
~~~

**4、Android 虚拟导航栏颜色控制（就是Android模拟器经常出现的那个底部黑色导航栏）**

![虚拟导航栏](https://upload-images.jianshu.io/upload_images/2828782-f88ddfaa72b26730.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

比较遗憾的是：

1、目前市面上绝大多数的应用都是没有做虚拟导航栏适配的（可能跟目前市面上的手机大多都是全面屏没人关心这个吧）

2、Flutter `ThemeData`里没有专门设置虚拟导航栏颜色的属性，讲道理`ThemeData`里面的
`brightness`属性理应同时控制状态栏文字颜色及icon颜色以及底部的虚拟导航栏背景及icon颜色的。但是Flutter官方不讲道理

好在Flutter提供了其它方式来更改系统栏的颜色，那就是 `SystemChrome.setSystemUIOverlayStyle`
该方法接收一个 `SystemUiOverlayStyle `样式用于控制系统UI（即状态栏及导航栏）其中`systemNavigationBarColor`用于控制导航栏背景色 `systemNavigationBarIconBrightness`用于控制导航栏icon深/浅色。在调用切换主题时同时调用 `SystemChrome.setSystemUIOverlayStyle`即可

~~~
 ///设置系统Bar主题
  static Future setSystemBarTheme() async {
    bool statusEnable =
        Platform.isAndroid ? await PlatformUtil.isStatusColorChange() : true;
    bool navigationEnable = Platform.isAndroid
        ? await PlatformUtil.isNavigationColorChange()
        : true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      ///状态栏背景色
      statusBarColor: darkMode || statusEnable ? Colors.transparent : null,
      ///状态栏icon 亮度（浅色/深色）
      statusBarIconBrightness: darkMode ? Brightness.light : Brightness.dark,
      ///导航栏颜色
      systemNavigationBarColor: darkMode
          ? colorBlackTheme
          : navigationEnable ? Colors.transparent : null,
      ///导航栏icon（浅色/深色）
      systemNavigationBarIconBrightness:
          darkMode ? Brightness.light : Brightness.dark,
    ));
  }
~~~

 ![导航栏颜色](https://user-gold-cdn.xitu.io/2020/6/26/172efe2e4416db12?w=436&h=892&f=gif&s=5501033)

是不是顿时感觉好不少啊（好开森😄）

但是如果我们从系统切换深色主题会怎样呢？

![深色模式异常](https://user-gold-cdn.xitu.io/2020/6/26/172efe2e4f9327fa?w=436&h=892&f=gif&s=9872093)

尼玛咋深色模式下导航栏还是浅色的，好突兀。
这个就是前面说到的因为Flutter `ThemeData`里没有专门设置虚拟导航栏颜色的属性，所以当系统切换深色模式导航栏没有任何变化
这咋整？

这里笔者尝试了不少，如前后台监听-这个只适合去设置页里面控制再返回，像这种从通知栏操作的App未进行前后台切换，不能做相应的操作。最终找到当系统主题切换会回调 `StatefulWidget`的`didUpdateWidget`方法，那不是可以在里面做相应操作？说试就试

~~~
@override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    LogUtil.e('home_page_didUpdateWidget');
    ///更新UI--在深色暗色模式切换时候也会触发因ThemeData无NavigationBar相关主题配置故采用该方法迂回处理
    if (_lastSetSystemUiAt == null ||
        DateTime.now().difference(_lastSetSystemUiAt) >
            Duration(milliseconds: 1000)) {
      ///两次点击间隔超过阈值则重新计时
      _lastSetSystemUiAt = DateTime.now();
      LogUtil.e('设置系统栏颜色');
      ThemeViewModel.setSystemBarTheme();
    }
  }
~~~

![深色模式正常](https://upload-images.jianshu.io/upload_images/2828782-8ae67f3936c095a0.gif?imageMogr2/auto-orient/strip)

哈哈，终于正常了！这里笔者采用了一个迂回笨的方式，如果有更好的方式请不吝赐教，感谢🙏

### 字体大小控制 

Freadhub还提供了资讯列表标题及简介字体大小控制的功能，主要通过 `Text ` widget的`textScaleFactor`属性控制,全局设置`articleTextScaleFactor`值修改后再刷新Widget即可

![字体大小控制](https://upload-images.jianshu.io/upload_images/2828782-645d7b58849d2be1.gif?imageMogr2/auto-orient/strip)


### 长按分享资讯功能

该功能涉及 `截屏`、`访问存储权限`、`保存图片`、`分享图片`等四个主体功能

**1、截屏**

Flutter提供专门用于截屏的widget `RepaintBoundary`只需将需要截屏的widget用`RepaintBoundary`包裹然后`GlobalKey`可以拿到`RenderRepaintBoundary`的引用并将其转化成图片数据`Uint8List`即可进行后续的保存图片及分享功能，需要注意的是将`RenderRepaintBoundary`转化成Image资源时需设置好pixelRatio一般获取设备像素比不然最终图片显示可能不清楚或者太大。这块网上例子很多。

~~~
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ///弹框宽度与屏幕宽度比值避免截图出来比预览更大
    ///分辨率通过获取设备的devicePixelRatio以达到清晰度良好
    var image = await boundary.toImage(pixelRatio: (MediaQuery.of(context).devicePixelRatio));
    ///转二进制
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    ///图片数据
    pngBytes = byteData.buffer.asUint8List();
~~~

**2、访问存储权限**

Freadhub使用的是三方库[`permission_handler`](https://pub.flutter-io.cn/packages/permission_handler)来完成Android端`Permission.storage`、iOS端`Permission.photos`权限申请，这个库做得比较不错，如果拒绝了还提供了跳转设置权限页方法。

~~~
  /// 申请权限
  static Future<bool> checkPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    if (status != PermissionStatus.granted) {
      status = await permission.request();
      return status == PermissionStatus.granted;
    } else {
      return true;
    }
  }

  ///文件读写android storage iOS photos
  static Future<bool> checkStoragePermission() async {
    return checkPermission(
        Platform.isAndroid ? Permission.storage : Permission.photos);
  }
~~~

Android端的还好，毕竟做Android出身的，iOS的适配还是出了个小插曲（其实也怪自己的英语太烂没注意😂而自己想当然的觉得了）。这里说一下避坑
[permission-handler github](https://github.com/Baseflow/flutter-permission-handler)官网 iOS的1、2步可以忽略(官网的1、2步意思是不需要的权限可将其移除；当时做的时候没有细看就自以为的觉得是需要啥权限就添加进去将注释去掉，可能是惯性思维😼),直接在`Info.plist`添加使用照片描述即可

~~~
<key>NSPhotoLibraryUsageDescription</key>
<string>保存图片到设备，需要调用你的照片功能</string>
~~~

**3、保存图片**

Freadhub使用三方库 `path_provider`用于获取本地文件路径并通过`File`对象将步骤一获取到的图片数据`Uint8List`保存到对应文件夹即可；
特殊说明:去年做的版本是用的一个三方库将图片保存到手机图库然后进行分享操作，最近做iOS适配检测时发现iOS保存图库没有返回File路径这样就无法进行图片File的分享。另外这种保存图库功能是调用一次则进行一次保存操作会造成同一图片多次保存情况，造成内存的浪费。故现使用File保存通过使用同一文件名以便同一图片多次保存的问题。
但是这造成另一个问题：**iOS应用创建的私有文件不能被其它应用使用😂**；故：iOS只提供分享按钮，用户可在弹出框通过选择`Save Image`进行保存图库然后其它应用可使用。

~~~
    ///保存图片到系统图库
    File saveFile = File(await getImagePath(imageName));
    bool exist = saveFile.existsSync() && saveFile.lengthSync() > 0;
    if (!exist) {
      if (!saveFile.existsSync()) {
        await saveFile.create();
      }
      File file = await saveFile.writeAsBytes(pngBytes);
      exist = file.existsSync();
    }
    if (exist) {
      fileImage = saveFile.absolute.path;
      saveImage(context, globalKey, imageName, share: share);
      return;
    }
~~~

**4、分享图片**

Flutter官方提供的`share`只提供简单的文字分享，故Freadhub使用三方库`flutter_share_plugin`。

~~~
 FlutterShare.shareFileWithText(
            filePath: fileImage, textContent: StringHelper.getS().saveImageShareTip);
~~~

Android真机 | iPad真机 | 
-|-
|![](https://upload-images.jianshu.io/upload_images/2828782-d5f3de7cb537df84.gif?imageMogr2/auto-orient/strip)| ![](https://upload-images.jianshu.io/upload_images/2828782-bf9d6fddc637bc8c.gif?imageMogr2/auto-orient/strip)|

### Android 应用升级

Android端App放在蒲公英上的，故也做了一个蒲公英的检测应用版本升级的功能。
有新版本则跳转浏览器由用户自己选择下载安装。

![Android应用更新](https://upload-images.jianshu.io/upload_images/2828782-f2afc893c2b7867b.gif?imageMogr2/auto-orient/strip)

## 使用到的三方库

能做成这个Freadhub小应用离不开这些三方库，在此感谢这些三方库的作者🙏

~~~
  #  国际化支持
  flutter_localizations:
    sdk: flutter
  # 状态管理State
  provider: ^3.2.0
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
  # 用于做骨架屏-闪光效果
  shimmer: ^1.1.1
  #  跳转系统浏览器/打电话等
  url_launcher: ^5.4.11
  #  二维码-生成
  qr_flutter: ^3.2.0
  #  工具类
  flustars: ^0.3.2
  #  动态权限申请
  permission_handler: ^5.0.1
  #  文件路径
  path_provider: ^1.6.11
  #  分享文字及文件-注意保存文件位置
  flutter_share_plugin: ^0.1.3+3
~~~

功能不多，用到的三方库还真不少😄

## 存在的坑

1、Android 相同的配置release打包处来的versionCode和debug不一致而且是直接加1000的那种（比如当前versionCode为4 release打包出来为1004）-网上没有搜到其他人有类似疑问也没有找到原因。

2、iOS的下拉刷新功能不管模拟器还是真机测试总会很容易出现动画及应用页面卡顿的情况

3、iOS运行真机过一会儿整个Android Studio会完全无响应需要杀进程才可以关掉

以上就是Freadhub开发过程遇到的目前还未有解决的疑惑坑点，如果有朋友知道希望解下小弟的疑惑，感谢🙏


##  工具推荐

做这个Freadhub过程还是用了俩不错的小工具，在这里给大家推荐下。

1、[Image Asset Icon Resizer Lite](https://apps.apple.com/cn/app/image-asset-icon-resizer-lite/id1108313046?mt=12) 一款方便的logo、启动页生成工具提供一种尺寸的图片可快速生成其它尺寸。支持Android 、iOS等

![Image Asset Icon Resizer Lite](https://upload-images.jianshu.io/upload_images/2828782-1ca927fecf6eeb49.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)

2、[GIPHY CAPTURE]( https://apps.apple.com/cn/app/giphy-capture-the-gif-maker/id668208984?mt=12) 一款很好用的gif录制软件，文章使用到的gif均是通过该软件录制而成

![GIPHY CAPTURE](https://upload-images.jianshu.io/upload_images/2828782-064b579e355f97df.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)

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
