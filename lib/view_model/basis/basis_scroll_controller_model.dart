import 'package:flutter/material.dart';
import 'package:flutter_readhub/util/log_util.dart';

///滚动回顶部
class ScrollTopModel with ChangeNotifier {
  ScrollController _scrollController;

  double _height;

  bool _showTopBtn = false;

  ScrollController get scrollController => _scrollController;

  bool get showTopBtn => _showTopBtn;

  ScrollTopModel(this._scrollController, {double height: 400}) {
    _height = height;
  }

  ///初始化滚动监听-一般在initState
  initListener() {
    _scrollController.addListener(() {
      bool show = _scrollController.offset > _height;
      if (show != _showTopBtn) {
        _showTopBtn = show;
        notifyListeners();
      }
    });
  }

  ///滚动到某个位置
  scrollTo({double offset, Duration duration, Curve curve}) {
    LogUtil.e("_scrollController.hasClients${_scrollController.hasClients}");
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      offset ?? 0,
      duration: duration ?? Duration(milliseconds: 500),
      curve: curve ?? Curves.easeInCirc,
    );
  }
}
