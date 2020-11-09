/// 页面状态类型
enum ViewState {
  ///加载中
  loading,

  ///暂无数据
  empty,

  ///加载失败
  error,

  ///成功
  success,
}

/// 错误类型
enum ErrorType {
  ///普通错误
  normal,

  ///网络错误
  network,
}

class ViewStateError {
  ErrorType errorType;
  String message;
  String errorMessage;

  ViewStateError(this.errorType, {this.message, this.errorMessage}) {
    errorType ??= ErrorType.normal;
    message ??= errorMessage;
  }

  bool get isNetworkError => errorType == ErrorType.network;

  @override
  String toString() {
    return 'ViewStateError{errorType: $errorType, message: $message, errorMessage: $errorMessage}';
  }
}
