import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/generated/i18n.dart';
import 'package:oktoast/oktoast.dart';

import 'view_state.dart';

///基础ViewModel
class BasisViewModel with ChangeNotifier {
  /// 当前的页面状态,默认为loading,可在viewModel的构造方法中指定;
  ViewState _viewState;

  /// 根据状态构造
  /// 子类可以在构造函数指定需要的页面状态
  BasisViewModel({ViewState viewState})
      : _viewState = viewState ?? ViewState.success;

  ViewState get viewState => _viewState;

  set viewState(ViewState viewState) {
    _viewStateError = null;
    _viewState = viewState;
    ///状态改变通知页面刷新
    notifyListeners();
  }

  ViewStateError _viewStateError;

  ViewStateError get viewStateError => _viewStateError;

  String get errorMessage => _viewStateError?.message;

  /// 以下变量是为了代码书写方便,加入的get方法.严格意义上讲,并不严谨

  bool get loading => viewState == ViewState.loading;

  bool get success => viewState == ViewState.success;

  bool get empty => viewState == ViewState.empty;

  bool get error => viewState == ViewState.error;

  void setSuccess() {
    viewState = ViewState.success;
  }

  void setLoading() {
    viewState = ViewState.loading;
  }

  void setEmpty() {
    viewState = ViewState.empty;
  }

  /// 未授权的回调
  void onUnAuthorizedException() {}

  /// [e]分类Error和Exception两种
  void setError(e, stackTrace, {String message}) {
    ErrorType errorType = ErrorType.normal;
    if (e is DioError) {
      e = e.error;
      if (e is HttpException) {
        stackTrace = null;
        message = e.message;
      } else {
        errorType = ErrorType.network;
      }
    }
    viewState = ViewState.error;
    _viewStateError = ViewStateError(
      errorType,
      message: message,
      errorMessage: e.toString(),
    );
    printErrorStack(e, stackTrace);
  }

  /// 显示错误消息
  showErrorMessage(context, {String message}) {
    if (viewStateError != null && message != null) {
      if (viewStateError.isNetworkError) {
        message ??= S.of(context).viewStateNetworkError;
      } else {
        message ??= viewStateError.message;
      }
      Future.microtask(() {
        showToast(message, context: context);
      });
    }
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _viewStateError: $_viewStateError}';
  }

}

/// [e]为错误类型 :可能为 Error , Exception ,String
/// [s]为堆栈信息
printErrorStack(e, s) {
  debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----error-----↓↓↓↓↓↓↓↓↓↓----->
$e
<-----↑↑↑↑↑↑↑↑↑↑-----error-----↑↑↑↑↑↑↑↑↑↑----->''');
  if (s != null) debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----trace-----↓↓↓↓↓↓↓↓↓↓----->
$s
<-----↑↑↑↑↑↑↑↑↑↑-----trace-----↑↑↑↑↑↑↑↑↑↑----->
    ''');
}
