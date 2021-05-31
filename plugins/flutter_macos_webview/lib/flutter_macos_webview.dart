import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const _kChannel = 'com.vanelizarov.flutter_macos_webview/method';

enum PresentationStyle {
  modal,
  sheet,
  // TODO: window
}

class FlutterMacOSWebView {
  /// Creates a [FlutterMacOSWebView] with the specified callbacks:
  ///
  /// [onOpen] - the WebView has been opened
  ///
  /// [onClose] - the WebView has been closed
  ///
  /// [onPageStarted] - the WebView has started loading
  /// url you've passed initially and for all subsequent url changes (user clicks a link, etc)
  ///
  /// [onPageFinished] - the WebView has finished loading url
  ///
  /// [onWebResourceError] - the WebView failed loading page or some Javascript exception occured.
  /// See [WebResourceErrorType] enum
  FlutterMacOSWebView({
    this.onOpen,
    this.onClose,
    this.onPageStarted,
    this.onPageFinished,
    this.onWebResourceError,
  }) : _channel = MethodChannel(_kChannel) {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  final MethodChannel _channel;

  final void Function()? onOpen;
  final void Function()? onClose;
  final void Function(String url)? onPageStarted;
  final void Function(String url)? onPageFinished;
  final void Function(WebResourceError error)? onWebResourceError;

  /// Opens WebView with specified params
  ///
  /// [url] - required param containing initial URL. Must not be null or empty
  ///
  /// [javascriptEnabled] - enables or disables Javascript execution until next `open` call.
  /// Must not be null
  ///
  /// [presentationStyle] - WebView window presentation style. Available styles
  /// are `modal` and `sheet` depending on which plugin calls respectively
  /// `presentAsModalWindow` or `presentAsSheet` from `NSViewController`.
  /// Must not be null
  ///
  /// [size] - size of the WebView in pixels
  ///
  /// [userAgent] - custom User Agent
  ///
  /// [modalTitle] - title for window when using `modal` presentation style
  ///
  /// [sheetCloseButtonTitle] - title for close button when using `sheet` presentation style
  Future<void> open({
    required String url,
    bool javascriptEnabled = true,
    PresentationStyle presentationStyle = PresentationStyle.sheet,
    Size? size,
    // Offset origin,
    String userAgent:'Mozilla/5.0 (iPhone; CPU iPhone OS 14_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
    String modalTitle = '',
    String sheetCloseButtonTitle = 'Close',
  }) async {
    assert(url.trim().isNotEmpty);

    await _channel.invokeMethod('open', {
      'url': url,
      'javascriptEnabled': javascriptEnabled,
      'presentationStyle': presentationStyle.index,
      'customSize': size != null,
      'width': size?.width,
      'height': size?.height,
      'userAgent': userAgent,
      'modalTitle': modalTitle,
      'sheetCloseButtonTitle': sheetCloseButtonTitle,
      // 'customOrigin': origin != null,
      // 'x': origin?.dx,
      // 'y': origin?.dy,
    });
  }

  /// Closes WebView
  Future<void> close() async {
    await _channel.invokeMethod('close');
  }

  Future<void> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onOpen':
        onOpen?.call();
        return;
      case 'onClose':
        onClose?.call();
        return;
      case 'onPageStarted':
        onPageStarted?.call(call.arguments['url']);
        return;
      case 'onPageFinished':
        onPageFinished?.call(call.arguments['url']);
        return;
      case 'onWebResourceError':
        onWebResourceError?.call(
          WebResourceError(
            errorCode: call.arguments['errorCode'],
            description: call.arguments['description'],
            domain: call.arguments['domain'],
            errorType: call.arguments['errorType'] == null
                ? null
                : WebResourceErrorType.values.firstWhere(
                    (type) {
                      return type.toString() ==
                          '$WebResourceErrorType.${call.arguments['errorType']}';
                    },
                  ),
          ),
        );
        return;
    }
  }
}

class WebResourceError {
  WebResourceError({
    required this.errorCode,
    required this.description,
    this.domain,
    this.errorType,
  });

  final int errorCode;
  final String description;
  final String? domain;
  final WebResourceErrorType? errorType;
}

/// Enum describing error types that can possibly return from plugin.
/// [Apple Docs](https://developer.apple.com/documentation/webkit/wkerror/code)
enum WebResourceErrorType {
  unknown,
  webContentProcessTerminated,
  webViewInvalidated,
  javaScriptExceptionOccurred,
  javaScriptResultTypeIsUnsupported,
}
