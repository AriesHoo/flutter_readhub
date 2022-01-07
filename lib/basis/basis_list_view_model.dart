import 'package:flutter_readhub/basis/basis_scroll_top_controller.dart';

import 'basis_view_model.dart';

/// 一次性获取列表数据
abstract class BasisListViewModel<T> extends BasisViewModel {
  ///ScrollController用于控制滚动逻辑
  BasisScrollTopController scrollTopController =
      BasisScrollTopController.defaultTopController();

  /// 页面数据
  List<T> list = [];

  /// 第一次进入页面loading skeleton
  initData() async {
    setLoading();
    await refresh(init: true);
  }

  /// 下拉刷新
  refresh({bool init = false}) async {
    try {
      List<T> data = (await loadData())!;
      if (data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        onCompleted(data);
        list.clear();
        list.addAll(data);
        setSuccess();
      }
    } catch (e, s) {
      if (init) list.clear();
      setError(e, s);
    }
  }

  /// 加载数据
  Future<List<T>?> loadData();

  onCompleted(List<T> data) {}

  @override
  void dispose() {
    scrollTopController.scrollController.dispose();
    super.dispose();
  }
}
