import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_readhub/data/article_http.dart';
import 'package:flutter_readhub/data/update_http.dart';
import 'package:flutter_readhub/generated/i18n.dart';
import 'package:flutter_readhub/util/log_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/basis/basis_scroll_controller_model.dart';
import 'package:flutter_readhub/view_model/theme_model.dart';
import 'package:flutter_readhub/view_model/update_model.dart';
import 'package:flutter_readhub/widget/article_item_widget.dart';
import 'package:flutter_readhub/widget/author_dialog.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

///主页面
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _listUrls = [
    ArticleHttp.API_TOPIC,
    ArticleHttp.API_NEWS,
    ArticleHttp.API_TECH_NEWS,
    ArticleHttp.API_BLOCK_CHAIN
  ];
  var _listTab = ["热门话题", "科技动态", "开发者资讯", "区块链"];
  TabController _tabController;
  ValueChanged<int> _onTabTap;
  List<ScrollTopModel> _scrollTopModel = [null, null, null, null];
  DateTime _lastPressedAt;

  ///上次点击时间

  void checkUpdate(BuildContext context) async {
    AppUpdateInfo info = await Provider.of<UpdateModel>(context).checkUpdate();
    if (info != null) {
      showUpdateDialog(context, info);
    }
    LogUtil.e('info:$info');
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: _listTab.length, vsync: this);
    _onTabTap = (i) {
      LogUtil.e('indexIsChanging:${_tabController.indexIsChanging};index:$i');

      ///点击非当前tab属于切换不进行回到顶部操作
      if (_tabController.indexIsChanging) {
        return;
      }
      try {
        _scrollTopModel[i]?.scrollTo();
      } catch (e) {
        LogUtil.e('scrollTopModel:$e');
      }
    };

    ///添加监听用于监控前后台转换
    WidgetsBinding.instance.addObserver(this);
    LogUtil.e("_MoviePageState_initState");
    Future.delayed(Duration(seconds: 5), () {
      checkUpdate(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      ///应用后台
    } else if (state == AppLifecycleState.resumed) {
      ///应用前台
      Provider.of<ThemeModel>(context)
          .switchTheme(userDarkMode: ThemeModel.darkMode);
    }
  }

  void switchDarkMode(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      ToastUtil.show("检测到系统为暗黑模式,已为你自动切换");
    } else {
      Provider.of<ThemeModel>(context).switchTheme(
          userDarkMode: Theme.of(context).brightness == Brightness.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt) >
                Duration(milliseconds: 1500)) {
          //两次点击间隔超过阈值则重新计时
          _lastPressedAt = DateTime.now();
          ToastUtil.show(S.of(context).quitApp,
              position: ToastPosition.bottom,
              duration: Duration(milliseconds: 1500));
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).cardColor,
        appBar: PreferredSize(
          ///设置AppBar高度
          preferredSize: Size.fromHeight(40),
          child: AppBar(
//            title: Text(
//              S.of(context).appName,
//              style: Theme.of(context).appBarTheme.textTheme.title.copyWith(
//                    fontStyle: FontStyle.normal,
//                  ),
//            ),
            title: Image.asset(
              'assets/images/title.png',
              width: 96,
              height: 96,
              color: ThemeModel.darkMode ? Colors.white : Colors.black,
              fit: BoxFit.fitWidth,
              colorBlendMode: BlendMode.srcIn,
            ),
            actions: <Widget>[
              ///更多信息
              AnimatedSwitcherIconWidget(
                defaultIcon: Icons.info,
                switchIcon: Icons.info_outline,
                tooltip: S.of(context).moreSetting,
                onPressed: () => showAuthorDialog(context),
              ),

              ///暗黑模式切换
              AnimatedSwitcherIconWidget(
                defaultIcon: Icons.brightness_2,
                switchIcon: Icons.brightness_5,
                tooltip: ThemeModel.darkMode
                    ? S.of(context).lightMode
                    : S.of(context).darkMode,
                onPressed: () => switchDarkMode(context),
              ),
            ],
          ),
        ),

        ///如此操作为了抽屉栏在上层AppBar之下否则这样做层次有点多
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 36,
              width: double.infinity,

              ///添加该属性去掉Tab按下水波纹效果
              color: Theme.of(context).appBarTheme.color,

              ///TabBar
              child: TabBarWidget(
                labels: _listTab,
                controller: _tabController,
                onTap: _onTabTap,
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Decorations.lineBoxBorder(context, bottom: true),
              ),
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                    _listTab.length,
                    (i) => ArticleItemWidget(
                          url: _listUrls[i],
                          onScrollTop: (top) => _scrollTopModel[i] = top,
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

///TabBar效果
class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    Key key,
    this.labels,
    this.controller,
    this.onTap,
  }) : super(key: key);
  final List labels;
  final TabController controller;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      onTap: onTap,
      tabs: List.generate(
          labels.length,
          (i) => Tab(
              child: Text(
                labels[i],
                softWrap: false,
                overflow: TextOverflow.fade,
                textScaleFactor: ThemeModel.textScaleFactor,
              ))),

      ///不自动滚动则均分屏幕宽度
      isScrollable: false,

      ///指示器高度
      indicatorWeight: 1.5,

      ///指示器颜色
      indicatorColor: Theme.of(context).accentColor,

      ///指示器样式-根据label宽度
      indicatorSize: TabBarIndicatorSize.label,

      ///选中label颜色
      labelColor: Theme.of(context).textTheme.title.color,

      ///未选择label颜色
      unselectedLabelColor:
          Theme.of(context).textTheme.title.color.withOpacity(0.6),
    );
  }
}

///添加切换动画IconButton
class AnimatedSwitcherIconWidget extends StatefulWidget {
  final IconData defaultIcon;
  final IconData switchIcon;
  final String tooltip;
  final VoidCallback onPressed;
  final Duration duration;

  const AnimatedSwitcherIconWidget({
    Key key,
    this.defaultIcon,
    this.switchIcon,
    this.tooltip,
    this.onPressed,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _AnimatedSwitcherIconWidgetState createState() =>
      _AnimatedSwitcherIconWidgetState();
}

class _AnimatedSwitcherIconWidgetState
    extends State<AnimatedSwitcherIconWidget> {
  IconData _actionIcon;

  _AnimatedSwitcherIconWidgetState();

  @override
  void initState() {
    super.initState();
    _actionIcon = widget.defaultIcon;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, anim) {
        return ScaleTransition(child: child, scale: anim);
      },
      duration: widget.duration,
      child: IconButton(
        tooltip: widget.tooltip,
        key: ValueKey(_actionIcon =
            ThemeModel.darkMode ? widget.switchIcon : widget.defaultIcon),
        icon: Icon(_actionIcon),
        onPressed: widget.onPressed,
      ),
    );
  }
}
