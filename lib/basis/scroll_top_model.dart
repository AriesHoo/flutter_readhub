import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

///滚动回顶部
class ScrollTopModel with ChangeNotifier {
  ScrollController _scrollController;

  late double _height;

  bool _showTopBtn = false;

  ///是否显示滚动到顶部
  bool _canScrollToTop = true;

  ScrollController get scrollController => _scrollController;

  bool get showTopBtn => _showTopBtn && _canScrollToTop;

  ///是否显示
  bool get canScrollToTop => _canScrollToTop;

  ScrollTopModel(
    this._scrollController, {
    double height: double.infinity,
    bool canScrollToTop: true,
  }) {
    _height = height;
    _canScrollToTop = canScrollToTop;
  }

  static ScrollTopModel defaultTopModel() => ScrollTopModel(
        ScrollController(),
        height: 2000,
      );

  setCanScrollTop(bool can) {
    _canScrollToTop = can;
    notifyListeners();
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
  scrollTo({double? offset, Duration? duration, Curve? curve}) {
    LogUtil.v("_scrollController.hasClients${_scrollController.hasClients}");
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
