import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

///加载网页
class WebViewPage extends StatefulWidget {
  const WebViewPage(
    this.url, {
    Key? key,
  }) : super(key: key);

  final String? url;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webViewController;
  ValueNotifier _getTitle = ValueNotifier("...");
  ValueNotifier _getProgress = ValueNotifier(true);
  String? _currentUrl;
  String? _title;

  _launchURL(String url) async {
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
  Widget build(BuildContext context) {
    _title = _title == null || _title!.isEmpty
        ? StringHelper.getS()!.loadingWebTitle
        : _title;
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
            'canGoBack:$canGoBack;currentUrl:$currentUrl;url:${widget.url}');
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
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.language),
              tooltip: StringHelper.getS()!.openBySystemBrowser,
              onPressed: () async {
                await launch(widget.url!);
              },
            ),
            IconButton(
              icon: Icon(Icons.share),
              tooltip: StringHelper.getS()!.share,
              onPressed: () async {
                await Share.share(
                    StringHelper.getS()!.saveImageShareTip + "   " + widget.url!);
              },
            ),
          ],
        ),
        body: Column(
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
                  initialUrl: widget.url,
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
      _title = title != null && title.isNotEmpty ? title : _title;
      return _getTitle.value = title;
    });
  }
}
