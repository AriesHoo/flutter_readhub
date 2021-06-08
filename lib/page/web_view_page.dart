import 'package:desktop_window/desktop_window.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_macos_webview/flutter_macos_webview.dart';
import 'package:flutter_readhub/dialog/url_share_dialog.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/manager/router_manger.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

///加载网页
class WebViewPage extends StatefulWidget {
  ///开启网页
  static start(
    BuildContext context,
    CardShareModel shareModel,
  ) async {
    if (PlatformUtil.isMobile) {
      await Navigator.push(
        context,
        PageRouteBuilder(
          settings: RouteSettings(name: RouteName.web_view_page),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              alwaysIncludeSemantics: true,
              child: WebViewPage(shareModel),
            );
          },
          fullscreenDialog: Platform.isIOS,
        ),
      );
    } else if (PlatformUtil.isMacOS) {
      final macOSWebView = FlutterMacOSWebView(
        onOpen: () => print('Opened'),
        onClose: () => print('Closed'),
        onPageStarted: (url) => print('Page started: $url'),
        onPageFinished: (url) => print('Page finished: $url'),
        onWebResourceError: (err) {
          print(
            'Error: ${err.errorCode}, ${err.errorType}, ${err.domain}, ${err.description}',
          );
        },
      );
      Size size = await DesktopWindow.getWindowSize();
      await macOSWebView.open(
        url: shareModel.url,
        presentationStyle: PresentationStyle.sheet,
        size: size,
        sheetCloseButtonTitle:
            MaterialLocalizations.of(context).closeButtonTooltip,
      );
    } else {
      await launch(shareModel.url);
    }
  }

  const WebViewPage(
    this.model, {
    Key? key,
  }) : super(key: key);

  final CardShareModel model;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webViewController;
  ValueNotifier _getTitle = ValueNotifier("...");
  ValueNotifier _getProgress = ValueNotifier(true);
  String? _currentUrl;
  String? _title;

  launchURL(String url) async {
    try {
      bool can = await canLaunch(url);
      if (can) {
        await launch(url);
      } else {
        await launch((await _webViewController.currentUrl())!);
      }
    } catch (e) {
      LogUtil.v('_launchURL:$e');
      await launch((await _webViewController.currentUrl())!);
    }
  }

  @override
  void initState() {
    super.initState();
    _title = widget.model.title;
    // Enable hybrid composition.
    if (PlatformUtil.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    _title = _title ?? StringHelper.getS()!.loadingWebTitle;
    return WillPopScope(
      onWillPop: () async {
        String? currentUrl = await _webViewController.currentUrl();
        bool canGoBack = await _webViewController.canGoBack();
        if (canGoBack) {
          _webViewController.goBack();
          String? current = await _webViewController.currentUrl();

          ///回退后当前url和回退前url一致直接退出页面
          if (currentUrl == current) {
            return true;
          }
        }
        LogUtil.v(
            'canGoBack:$canGoBack;currentUrl:$currentUrl;url:${widget.model.url}');
        return !canGoBack;
//        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: ValueListenableBuilder(
            valueListenable: _getTitle,
            builder: (context, dynamic title, child) => Text(
              _title!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textScaleFactor: ThemeViewModel.textScaleFactor,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              tooltip: StringHelper.getS()!.share,
              onPressed: () => _showShare(),
            ),
          ],
        ),
        body: Hero(
          tag: widget.model.url,
          child: Column(
            children: <Widget>[
              /// 模糊进度条(会执行一个动画)
              ValueListenableBuilder(
                valueListenable: _getProgress,
                builder: (context, dynamic loading, child) {
                  return Container(
                    height: loading ? 2 : 0,
                    child: LinearProgressIndicator(
                      backgroundColor: Theme.of(context).appBarTheme.color,
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    ),
                  );
                },
              ),
              Expanded(
                flex: 1,
                child: SafeArea(
                  child: WebView(
                    initialUrl: widget.model.url,
                    debuggingEnabled: false,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialMediaPlaybackPolicy:
                        AutoMediaPlaybackPolicy.always_allow,
                    navigationDelegate: (NavigationRequest request) {
                      debugPrint('导航$request');
                      refreshNavigator();
                      if (!request.url.startsWith('http')) {
//                      _launchURL(request.url);
                        return NavigationDecision.prevent;
                      } else {
                        if (request.url.contains(".apk")) {
//                        _launchURL(request.url);
                          return NavigationDecision.prevent;
                        }
                        return NavigationDecision.navigate;
                      }
                    },
                    onWebViewCreated: (WebViewController web) {
                      debugPrint("onWebViewCreated");
                      _webViewController = web;

                      ///webView 创建调用，
                      web.currentUrl().then((url) {
                        ///返回当前url
                        _currentUrl = url;
                        debugPrint("_currentUrl:" + _currentUrl!);
                      });
                    },
                    onPageFinished: (String value) async {
                      debugPrint("onPageFinished:" + value);
                      refreshNavigator();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.share),
          tooltip: StringHelper.getS()!.share,
          onPressed: () => _showShare(),
        ),
      ),
    );
  }

  /// 刷新导航按钮
  ///
  /// 目前主要用来控制 '前进','后退'按钮是否可以点击
  /// 但是目前该方法没有合适的调用时机.
  /// 在[onPageFinished]中,会遗漏正在加载中的状态
  /// 在[navigationDelegate]中,会存在页面还没有加载就已经判断过了.
  void refreshNavigator() {
    _webViewController.getTitle().then((title) {
      _getProgress.value = title == null || title.isEmpty;
      LogUtil.v("getTitle:" + title!);
      _title = !TextUtil.isEmpty(title) ? title : _title;
      return _getTitle.value = title;
    });
  }

  ///弹出分享选择
  _showShare() {
    UrlShareDialog.start(widget.model);
  }
}
