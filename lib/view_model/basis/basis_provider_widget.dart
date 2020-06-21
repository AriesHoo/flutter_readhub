import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/generated/l10n.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'basis_list_view_model.dart';
import 'basis_refresh_list_view_model.dart';
import 'basis_scroll_controller_model.dart';
import 'view_state_widget.dart';

/// Provider简单抽离方便数据初始化
class BasisProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final ValueWidgetBuilder<T> builder;
  final T model;
  final Widget child;
  final Function(T) onModelReady;

  BasisProviderWidget({
    Key key,
    @required this.builder,
    @required this.model,
    this.child,
    this.onModelReady,
  }) : super(key: key);

  _BasisProviderWidgetState<T> createState() => _BasisProviderWidgetState<T>();
}

class _BasisProviderWidgetState<T extends ChangeNotifier>
    extends State<BasisProviderWidget<T>> {
  T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    if (model != null) {
      model.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

///获取单个list列表
class BasisListProviderWidget<T extends BasisListViewModel>
    extends BasisProviderWidget<T> {
  BasisListProviderWidget({
    Key key,
    @required ValueWidgetBuilder<T> builder,
    @required T model,
    Function(T) onModelReady,
    ValueWidgetBuilder<T> loadingBuilder,
    ValueWidgetBuilder<T> emptyBuilder,
    ValueWidgetBuilder<T> errorBuilder,
    Widget child,
  }) : super(
            key: key,
            model: model,
            child: child,
            onModelReady: (model) {
              model.initData();
              onModelReady?.call(model);
            },
            builder: (context, model, child) {
              if (model.loading) {
                return loadingBuilder != null
                    ? loadingBuilder(context, model, child)
                    : LoadingStateWidget();
              } else if (model.empty) {
                return emptyBuilder != null
                    ? emptyBuilder(context, model, child)
                    : EmptyStateWidget();
              } else if (model.error && model.list.isEmpty) {
                return errorBuilder != null
                    ? errorBuilder(context, model, child)
                    : ErrorStateWidget(
                        error: model.viewStateError, onPressed: model.initData);
              }
              return builder(context, model, child);
            });
}

///配合下拉刷新功能--配合上拉加载更多及返回顶部
class BasisRefreshListProviderWidget<A extends BasisRefreshListViewModel,
    B extends ScrollTopModel> extends BasisProviderWidget2<A, B> {
  BasisRefreshListProviderWidget({
    Key key,
    @required
        Widget Function(BuildContext context, A model, int index) itemBuilder,
    @required A model1,
    @required B model2,
    Function(A, B) onModelReady,
    Function(BuildContext context, A model1, B model2, Widget child)
        loadingBuilder,
    Function(BuildContext context, A model1, B model2, Widget child)
        emptyBuilder,
    Function(BuildContext context, A model1, B model2, Widget child)
        errorBuilder,
    Widget child,
  }) : super(
            key: key,
            model1: model1,
            model2: model2 ?? ScrollTopModel(ScrollController(), height: 400),
            child: child,
            onModelReady: (model1, model2) {
              ///加载数据
              model1.initData();

              ///初始化滚动监听
              model2.initListener();

              ///初始化完成回调
              onModelReady?.call(model1, model2);
            },
            builder: (context, model, model2, child) {
              if (model.loading) {
                return loadingBuilder != null
                    ? loadingBuilder(context, model, model2, child)
                    : LoadingStateWidget();
              } else if (model.empty) {
                return emptyBuilder != null
                    ? emptyBuilder(context, model, model2, child)
                    : EmptyStateWidget();
              } else if (model.error && model.list.isEmpty) {
                return errorBuilder != null
                    ? errorBuilder(context, model, model2, child)
                    : ErrorStateWidget(
                        error: model.viewStateError, onPressed: model.initData);
              }

              ///加载成功后
              return Scaffold(
                body: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header:Platform.isAndroid? MaterialClassicHeader(
                    backgroundColor: Colors.white,
                    color: ThemeViewModel.accentColor,
                  ):ClassicHeader(),
                  footer: SmartLoadFooterWidget(),

                  ///下拉刷新监听
                  onRefresh: model.refresh,

                  ///上拉加载更多监听
                  onLoading: model.loadMore,

                  ///刷新控制器
                  controller: model.refreshController,

                  ///子控件ListView
                  child: ListView.builder(
                    ///滚动监听-用于控制直达顶部功能
                    controller: model2.scrollController,

                    ///内容适配
                    shrinkWrap: true,
//                    physics: ClampingScrollPhysics(),
                    itemCount: model.list.length,
                    itemBuilder: (context, index) {
                      return itemBuilder(context, model, index);
                    },
                  ),
                ),
                floatingActionButton:
                    !model2.showTopBtn || ThemeViewModel.hideFloatingButton
                        ? null
                        : FloatingActionButton(
                            backgroundColor: Theme.of(context).accentColor,
                            child: Icon(
                              Icons.vertical_align_top,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (model2 is ScrollTopModel) {
                                model2.scrollTo();
                              }
                            },
                          ),
              );
            });
}

class BasisProviderWidget2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends StatefulWidget {
  final Widget Function(BuildContext context, A model1, B model2, Widget child)
      builder;
  final A model1;
  final B model2;
  final Widget child;
  final Function(A, B) onModelReady;

  BasisProviderWidget2({
    Key key,
    @required this.builder,
    @required this.model1,
    @required this.model2,
    this.child,
    this.onModelReady,
  }) : super(key: key);

  _BasisProviderWidgetState2<A, B> createState() =>
      _BasisProviderWidgetState2<A, B>();
}

class _BasisProviderWidgetState2<A extends ChangeNotifier,
    B extends ChangeNotifier> extends State<BasisProviderWidget2<A, B>> {
  A model1;
  B model2;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;
    widget.onModelReady?.call(model1, model2);
    super.initState();
  }

  @override
  void dispose() {
    if (model1 != null) {
      model1.dispose();
    }
    if (model2 != null) {
      model2.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<A>.value(value: model1),
          ChangeNotifierProvider<B>.value(value: model2),
        ],
        child: Consumer2<A, B>(
          builder: widget.builder,
          child: widget.child,
        ));
  }
}

///刷新脚
class SmartLoadFooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      height: 50,
      builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(
            S.of(context).loadIdle,
            textScaleFactor: ThemeViewModel.textScaleFactor,
            style: Theme.of(context).textTheme.caption,
          );
        } else if (mode == LoadStatus.loading) {
          body = CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = Text(
            S.of(context).loadFailed,
            textScaleFactor: ThemeViewModel.textScaleFactor,
            style: Theme.of(context).textTheme.caption,
          );
        } else if (mode == LoadStatus.canLoading) {
          body = Text(
            S.of(context).loadIdle,
            textScaleFactor: ThemeViewModel.textScaleFactor,
            style: Theme.of(context).textTheme.caption,
          );
        } else {
          body = Text(
            S.of(context).loadNoMore,
            textScaleFactor: ThemeViewModel.textScaleFactor,
            style: Theme.of(context).textTheme.caption,
          );
        }
        return Container(
          height: 50,
          child: Center(child: body),
        );
      },
    );
  }
}
