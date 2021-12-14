import 'package:flutter/material.dart';

///滚动回顶部
class BasisScrollTopController {
  ///滚动控制器
  ScrollController scrollController;

  ///滚动高度阈值
  late double _height;

  ///是否滚动到达阈值
  bool _showTopBtn = false;

  ///是否显示滚动到顶部
  bool _canScrollToTop = true;

  bool get showTopBtn => _showTopBtn && _canScrollToTop;

  ///是否显示
  bool get canScrollToTop => _canScrollToTop;

  ///通知回到顶部Widget 刷新
  ValueNotifier<bool> scrollWidgetNotifier = ValueNotifier(false);

  BasisScrollTopController({
    required this.scrollController,
    double? height,
    bool canScrollToTop: true,
  }) {
    _height = height ?? 500;
    _canScrollToTop = canScrollToTop;
  }

  static BasisScrollTopController defaultTopController() =>
      BasisScrollTopController(
        scrollController: ScrollController(),
      );

  setCanScrollTop(bool can) {
    _canScrollToTop = can;
    scrollWidgetNotifier.value = showTopBtn;
  }

  ///初始化滚动监听-一般在initState
  initListener() {
    scrollController.addListener(() {
      bool show = scrollController.offset >= _height;
      if (show != _showTopBtn) {
        _showTopBtn = show;
        scrollWidgetNotifier.value = showTopBtn;
      }
    });
  }

  ///滚动到某个位置
  scrollTo({double? offset, Duration? duration, Curve? curve}) {
    if (!scrollController.hasClients) {
      return;
    }
    scrollController.animateTo(
      offset ?? 0,
      duration: duration ?? Duration(milliseconds: 500),
      curve: curve ?? Curves.easeInCirc,
    );
  }
}
