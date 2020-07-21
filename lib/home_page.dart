import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_readhub/data/article_http.dart';
import 'package:flutter_readhub/dialog/author_dialog.dart';
import 'package:flutter_readhub/generated/l10n.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/basis/basis_scroll_controller_model.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:flutter_readhub/view_model/update_view_model.dart';
import 'package:flutter_readhub/widget/article_item_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

///主页面
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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

  ///上次点击时间
  DateTime _lastPressedAt;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: _listTab.length, vsync: this);
    _onTabTap = (i) {
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

    ///5s后进行版本检测
    Future.delayed(Duration(seconds: 5), () {
      UpdateViewModel().checkUpdate(context);
    });
  }

  ///深色浅色模式切换
  void switchDarkMode(BuildContext context) {
    if (ThemeViewModel.platformDarkMode) {
      ToastUtil.show(StringHelper.getS().tipSwitchThemeWhenPlatformDark);
    } else {
      Provider.of<ThemeViewModel>(context).switchTheme(
          userDarkMode: Theme.of(context).brightness == Brightness.light);
    }
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    LogUtil.e('home_page_didUpdateWidget');
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt) >
                Duration(milliseconds: 1500)) {
          ///两次点击间隔超过阈值则重新计时
          _lastPressedAt = DateTime.now();
          ToastUtil.show(StringHelper.getS().quitApp,
              position: ToastPosition.bottom,
              duration: Duration(milliseconds: 1500));
          return false;
        }
        exit(0);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).cardColor,
        appBar: PreferredSize(
          ///设置AppBar高度
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            title: Image.asset(
              'assets/images/title.png',
              width: 108,
              color: Theme.of(context).appBarTheme.iconTheme.color,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
              colorBlendMode: BlendMode.srcIn,
            ),
            actions: <Widget>[
              ///更多信息
              AnimatedSwitcherIconWidget(
                defaultIcon: Icons.info,
                switchIcon: Icons.info_outline,
                tooltip: StringHelper.getS().moreSetting,
                onPressed: () => showAuthorDialog(context),
                checkTheme: true,
              ),

              ///暗黑模式切换
              AnimatedSwitcherIconWidget(
                defaultIcon: Icons.brightness_2,
                switchIcon: Icons.brightness_5,
                tooltip: ThemeViewModel.darkMode
                    ? StringHelper.getS().lightMode
                    : StringHelper.getS().darkMode,
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
                textScaleFactor: ThemeViewModel.textScaleFactor,
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
  final bool checkTheme;

  const AnimatedSwitcherIconWidget({
    Key key,
    this.defaultIcon,
    this.switchIcon,
    this.tooltip,
    this.onPressed,
    this.duration = const Duration(milliseconds: 500),
    this.checkTheme: false,
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

  DateTime _lastSetSystemUiAt;

  @override
  void didUpdateWidget(AnimatedSwitcherIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.checkTheme) {
      return;
    }

    ///更新UI--在深色暗色模式切换时候也会触发因ThemeData无NavigationBar相关主题配置故采用该方法迂回处理
    if (_lastSetSystemUiAt == null ||
        DateTime.now().difference(_lastSetSystemUiAt) >
            Duration(milliseconds: 1000)) {
      ///两次点击间隔超过阈值则重新计时
      _lastSetSystemUiAt = DateTime.now();
      LogUtil.e('设置系统栏颜色');
      ThemeViewModel.setSystemBarTheme();
    }
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
            ThemeViewModel.darkMode ? widget.switchIcon : widget.defaultIcon),
        icon: Icon(_actionIcon),
        onPressed: widget.onPressed,
      ),
    );
  }
}
