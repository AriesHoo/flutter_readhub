import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/view_state.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';

/// 加载中
class LoadingStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.all(20),
          child: CupertinoActivityIndicator(
            radius: 12,
          ),
        ),
      ),
    );
  }
}

/// 基础Widget
class ViewStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;
  final VoidCallback onPressed;

  ViewStateWidget(
      {Key? key,
      this.image,
      this.title,
      this.message,
      this.buttonText,
      required this.onPressed,
      this.buttonTextData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Colors.grey,
          fontSize: 14,
        );
    var messageStyle = titleStyle.copyWith(
        color: titleStyle.color!.withOpacity(0.7), fontSize: 14);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        image ?? Icon(Icons.error, size: 80, color: Colors.grey[500]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title ?? appString.viewStateError,
                style: titleStyle,
                textScaleFactor: ThemeViewModel.textScaleFactor,
              ),
              SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 200, minHeight: message != null ? 10 : 0),
                child: SingleChildScrollView(
                  child: Text(
                    message ?? '',
                    style: messageStyle,
                    textScaleFactor: ThemeViewModel.textScaleFactor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: ViewStateButton(
            child: buttonText,
            textData: buttonTextData,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}

///错误视图
class ErrorStateWidget extends StatelessWidget {
  final ViewStateError? error;
  final String? title;
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;
  final VoidCallback onPressed;

  const ErrorStateWidget({
    Key? key,
    required this.error,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.buttonTextData,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultImage;
    var defaultTitle;
    var errorMessage = error!.message;
    String defaultTextData = appString.viewStateRetry;
    switch (error!.errorType) {
      case ErrorType.network:
        defaultImage =
            const Icon(Icons.network_check, size: 80, color: Colors.grey);
        defaultTitle = appString.viewStateNetworkError;
        errorMessage = ''; // 网络异常移除message提示
        break;
      case ErrorType.normal:
        defaultImage = const Icon(Icons.error, size: 80, color: Colors.grey);
        defaultTitle = appString.viewStateError;
        break;
    }

    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ?? defaultImage,
      title: title ?? defaultTitle,
      message: message ?? errorMessage,
      buttonTextData: buttonTextData ?? defaultTextData,
      buttonText: buttonText,
    );
  }
}

/// 页面无数据
class EmptyStateWidget extends StatelessWidget {
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final VoidCallback onPressed;

  const EmptyStateWidget(
      {Key? key,
      this.image,
      this.message,
      this.buttonText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ??
          const Icon(Icons.hourglass_empty, size: 100, color: Colors.grey),
      title: message ?? appString.viewStateEmpty,
      buttonText: buttonText,
      buttonTextData: appString.viewStateRefresh,
    );
  }
}

/// 公用Button
class ViewStateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;
  final String? textData;

  const ViewStateButton({
    required this.onPressed,
    this.child,
    this.textData,
  }) : assert(child == null || textData == null);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: child ??
          Text(
            textData ?? appString.viewStateRetry,
            textScaleFactor: ThemeViewModel.textScaleFactor,
          ),
      style: buttonStyle(primaryColor: Theme.of(context).primaryColor),
      onPressed: onPressed,
    );
  }
}

///Button样式
ButtonStyle buttonStyle({required Color primaryColor}) {
  return ButtonStyle(
      enableFeedback: true,
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      alignment: Alignment.center,
      padding: MaterialStateProperty.all(
        EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.pressed)
            ? primaryColor.withOpacity(0.75)
            : primaryColor,
      ),
      overlayColor: MaterialStateProperty.all(
        Colors.transparent,
      ),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 14)));
}
