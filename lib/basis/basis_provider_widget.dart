import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/basis_list_view_model.dart';
import 'package:flutter_readhub/basis/basis_refresh_list_view_model.dart';
import 'package:flutter_readhub/basis/view_state_widget.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// Provider简单抽离方便数据初始化
class BasisProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T model;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;
  final Function(T)? onModelReady;

  const BasisProviderWidget({
    Key? key,
    required this.model,
    required this.builder,
    this.child,
    this.onModelReady,
  }) : super(key: key);

  @override
  _BasisProviderWidgetState<T> createState() => _BasisProviderWidgetState<T>();
}

class _BasisProviderWidgetState<T extends ChangeNotifier>
    extends State<BasisProviderWidget<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    model.dispose();
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
    Key? key,
    required ValueWidgetBuilder<T> builder,
    required T model,
    Function(T)? onModelReady,
    ValueWidgetBuilder<T>? loadingBuilder,
    ValueWidgetBuilder<T>? emptyBuilder,
    ValueWidgetBuilder<T>? errorBuilder,
    Widget? child,
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
                    : EmptyStateWidget(
                        onPressed: model.initData,
                      );
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
class BasisRefreshListProviderWidget<A extends BasisRefreshListViewModel>
    extends BasisProviderWidget<A> {
  BasisRefreshListProviderWidget({
    Key? key,
    Widget Function(BuildContext context, A model, int index)? itemBuilder,
    required A model,
    Widget Function(BuildContext context, A model)? childBuilder,
    Function(A)? onModelReady,
    Widget Function(BuildContext context, A model, Widget? child)?
        loadingBuilder,
    Widget Function(BuildContext context, A model, Widget? child)? emptyBuilder,
    Widget Function(BuildContext context, A model, Widget? child)? errorBuilder,
    Widget? child,
  }) : super(
            key: key,
            model: model,
            child: child,
            onModelReady: (m1) {
              ///加载数据
              m1.initData();

              ///初始化滚动监听
              m1.scrollTopController.initListener();

              ///初始化完成回调
              onModelReady?.call(m1);

              ///非移动端滚动到底部有未触发加载下一页操作
              m1.scrollTopController.scrollController.addListener(() {
                if (m1.scrollTopController.scrollController.position.pixels ==
                    m1.scrollTopController.scrollController.position
                        .maxScrollExtent) {
                  LogUtil.e('footerStatus:${m1.refreshController.footerStatus}',
                      tag: 'footerStatusTag');

                  ///非加载中且非无更多数据
                  if (m1.refreshController.footerStatus != LoadStatus.noMore &&
                      !m1.refreshController.isLoading) {
                    ///此处主要为实现更新底部loadingUI及触发加载更多回调使用
                    ///footerMode?.value 设置加载状态形式不使用requestLoading()
                    ///非手机端requestLoading()测试正常 手机端会异常
                    m1.refreshController.footerMode?.value = LoadStatus.loading;
                  }
                }
              });
            },
            builder: (context, m1, child) {
              if (m1.loading) {
                return loadingBuilder != null
                    ? loadingBuilder(context, m1, child)
                    : LoadingStateWidget();
              } else if (m1.empty) {
                return emptyBuilder != null
                    ? emptyBuilder(context, m1, child)
                    : EmptyStateWidget(
                        onPressed: m1.initData,
                      );
              } else if (m1.error && m1.list.isEmpty) {
                return errorBuilder != null
                    ? errorBuilder(context, m1, child)
                    : ErrorStateWidget(
                        error: m1.viewStateError,
                        onPressed: m1.initData,
                      );
              }

              ///加载成功后
              return Scaffold(
                body: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: PlatformUtil.isAndroid
                      ? MaterialClassicHeader(
                          backgroundColor: Colors.white,
                          color: ThemeViewModel.primaryColor,
                        )
                      : ClassicHeader(
                          ///文字样式
                          textStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                          refreshingIcon: !PlatformUtil.isAndroid
                              ? const CupertinoActivityIndicator()
                              : const SizedBox(
                                  width: 18.0,
                                  height: 18.0,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.0),
                                ),
                        ),
                  footer: SmartLoadFooterWidget(
                    controller: m1.refreshController,
                  ),

                  ///下拉刷新监听
                  onRefresh: m1.refresh,

                  ///上拉加载更多监听
                  onLoading: m1.loadMore,

                  ///刷新控制器
                  controller: m1.refreshController,

                  ///子控件ListView
                  child: childBuilder != null
                      ? childBuilder(context, m1)
                      : ListView.builder(
                          ///滚动监听-用于控制直达顶部功能
                          controller: m1.scrollTopController.scrollController,

                          ///内容适配
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: m1.list.length,
                          itemBuilder: (context, index) {
                            return itemBuilder != null
                                ? itemBuilder(context, m1, index)
                                : const SizedBox();
                          },
                        ),
                ),
                floatingActionButton: ValueListenableBuilder<bool>(
                  valueListenable: m1.scrollTopController.scrollWidgetNotifier,
                  builder: (BuildContext context, bool show, Widget? child) =>
                      show && !ThemeViewModel.hideFloatingButton
                          ? FloatingActionButton.extended(
                              label: Text(appString.tooltipScrollTop),
                              icon: const Icon(
                                Icons.file_upload,
                              ),
                              onPressed: () {
                                m1.scrollTopController.scrollTo();
                              },
                            )
                          : const SizedBox(),
                ),
              );
            });
}

class BasisProviderWidget2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends StatefulWidget {
  final Widget Function(BuildContext context, A model1, B model2, Widget? child)
      builder;
  final A model1;
  final B model2;
  final Widget? child;
  final Function(A, B)? onModelReady;

  const BasisProviderWidget2({
    Key? key,
    required this.builder,
    required this.model1,
    required this.model2,
    this.child,
    this.onModelReady,
  }) : super(key: key);

  @override
  _BasisProviderWidgetState2<A, B> createState() =>
      _BasisProviderWidgetState2<A, B>();
}

class _BasisProviderWidgetState2<A extends ChangeNotifier,
    B extends ChangeNotifier> extends State<BasisProviderWidget2<A, B>> {
  late A model1;
  late B model2;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;
    widget.onModelReady?.call(model1, model2);
    super.initState();
  }

  @override
  void dispose() {
    model1.dispose();
    model2.dispose();
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
  final RefreshController? controller;

  const SmartLoadFooterWidget({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double safeBottom = MediaQueryData.fromWindow(window).padding.bottom;
    LogUtil.e('safeBottom:$safeBottom');
    return CustomFooter(
      height: 50 + safeBottom,
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(
            appString.loadIdle,
            textScaleFactor: ThemeViewModel.textScaleFactor,
            style: Theme.of(context).textTheme.caption,
          );
        } else if (mode == LoadStatus.loading) {
          body = const CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = Text(
            appString.loadFailed,
            textScaleFactor: ThemeViewModel.textScaleFactor,
            style: Theme.of(context).textTheme.caption,
          );
        } else if (mode == LoadStatus.canLoading) {
          body = Text(
            appString.loadIdle,
            textScaleFactor: ThemeViewModel.textScaleFactor,
            style: Theme.of(context).textTheme.caption,
          );
        } else {
          body = Text(
            appString.loadNoMore,
            textScaleFactor: ThemeViewModel.textScaleFactor,
            style: Theme.of(context).textTheme.caption,
          );
        }
        return SizedBox(
          height: 50 + safeBottom,
          child: Padding(
            padding: EdgeInsets.only(bottom: safeBottom),
            child: Center(
              child: GestureDetector(
                onTap: () => controller?.requestLoading(),
                child: body,
              ),
            ),
          ),
        );
      },
    );
  }
}
