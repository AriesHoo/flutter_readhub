import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_readhub/data/article_http.dart';
import 'package:flutter_readhub/dialog/author_dialog.dart';
import 'package:flutter_readhub/helper/provider_helper.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/model/tab_model.dart';
import 'package:flutter_readhub/page/article_item_widget.dart';
import 'package:flutter_readhub/util/adaptive.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:flutter_readhub/view_model/update_view_model.dart';
import 'package:flutter_readhub/widget/animated_switcher_icon_widget.dart';
import 'package:flutter_readhub/widget/tab_bar_widget.dart';

///深色浅色模式切换
void switchDarkMode(BuildContext context) {
  if (ThemeViewModel.platformDarkMode) {
    ToastUtil.show(StringHelper.getS()!.tipSwitchThemeWhenPlatformDark);
  } else {
    ProviderHelper.of<ThemeViewModel>(context).switchTheme(
        userDarkMode: Theme.of(context).brightness == Brightness.light);
  }
}

///主页面
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ///tab标签
  List<TabModel> _listTab = [];
  TabController? _tabController;
  PageController? _pageController;

  ///上次点击时间
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    _listTab.add(
      TabModel(
        '热门话题',
        ArticleHttp.API_TOPIC,
        icon: Icons.hot_tub,
      ),
    );
    _listTab.add(
      TabModel(
        '科技动态',
        ArticleHttp.API_NEWS,
        icon: Icons.timer,
      ),
    );
    _listTab.add(
      TabModel(
        '技术资讯',
        ArticleHttp.API_TECH_NEWS,
        icon: Icons.info_sharp,
      ),
    );
    _listTab.add(
      TabModel(
        '区块链',
        ArticleHttp.API_BLOCK_CHAIN,
        icon: Icons.block,
      ),
    );
    _tabController =
        TabController(initialIndex: 0, length: _listTab.length, vsync: this);
    _pageController = PageController();
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        _pageController?.jumpToPage(_tabController!.index);
      }
    });

    ///非手机系统不做检测版本更新
    if (!PlatformUtil.isMobile) {
      return;
    }

    ///5s后进行版本检测
    Future.delayed(Duration(seconds: 5), () {
      UpdateViewModel().checkUpdate(context);
    });
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    LogUtil.v('home_page_didUpdateWidget');
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
    _pageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///返回键控制
    return WillPopScope(
      onWillPop: () async {
        ///非手机不做拦截
        if (!PlatformUtil.isMobile) {
          return true;
        }
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                Duration(milliseconds: 1500)) {
          ///两次点击间隔超过阈值则重新计时
          _lastPressedAt = DateTime.now();
          ToastUtil.show(
            StringHelper.getS()!.quitApp,
            duration: Duration(milliseconds: 1500),
            notification: false,
          );
          return false;
        }
        exit(0);
        return true;
      },
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return HomeBody(
                _listTab,
                controller: _tabController,
                pageController: _pageController,
              );
            },
          ),
          SplashPage(),
        ],
      ),
    );
  }
}

///主页面主体
class HomeBody extends StatelessWidget {
  const HomeBody(
    this.tabs, {
    Key? key,
    required this.controller,
    required this.pageController,
    this.onTap,
  }) : super(key: key);
  final List<TabModel> tabs;
  final TabController? controller;
  final PageController? pageController;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    bool displayDesktop = isDisplayDesktop;
    LogUtil.v('HomeBody:${MediaQuery.of(context).size.width}');

    ///分页tab
    Widget tabWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ///tab栏
        Container(
          height: displayDesktop ? 0 : 36,
          width: double.infinity,

          ///TabBar
          child: TabBarWidget(
            labels: tabs.map((e) => e.label).toList(),
            controller: controller,

            ///桌面端且大屏禁用水平滑动切换tab
            physics: PlatformUtil.isDesktop && displayDesktop
                ? NeverScrollableScrollPhysics()
                : null,
          ),

          ///添加下划线装饰
          decoration: BoxDecoration(
            border: Decorations.lineBoxBorder(
              context,
              bottom: !displayDesktop,
            ),

            ///添加该属性去掉Tab按下水波纹效果
            color: Theme.of(context).appBarTheme.color,
          ),
        ),
        Expanded(
          flex: 1,
          child: PageView.builder(
            itemBuilder: (context, index) => ArticleItemWidget(tabs[index].url),
            itemCount: tabs.length,
            onPageChanged: (index) => controller?.animateTo(index),
            controller: pageController,

            ///桌面端且大屏禁用水平滑动切换tab
            physics: PlatformUtil.isDesktop && displayDesktop
                ? NeverScrollableScrollPhysics()
                : null,
          ),
          // child: TabBarView(
          //   controller: controller,
          //
          //   ///桌面端且大屏禁用水平滑动切换tab
          //   physics: PlatformUtil.isDesktop && displayDesktop
          //       ? NeverScrollableScrollPhysics()
          //       : null,
          //   children: List.generate(
          //     tabs.length,
          //     (i) => ArticleItemWidget(tabs[i].url),
          //   ),
          // ),
        )
      ],
    );
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,

      ///顶部App标题
      appBar: PreferredSize(
        ///设置AppBar高度--大屏幕另外一种显示模式
        preferredSize: Size.fromHeight(displayDesktop ? 0 : 40),
        child: AppBar(
          backgroundColor: displayDesktop ? Theme.of(context).cardColor : null,
          title: AppIcon(),
          actions: <Widget>[
            ///更多信息
            AnimatedSwitcherIconWidget(
              defaultIcon: Icons.info,
              switchIcon: Icons.info_outline,
              tooltip: StringHelper.getS()!.moreSetting,
              onPressed: () => showAuthorDialog(context),
              checkTheme: true,
            ),

            ///暗黑模式切换
            AnimatedSwitcherIconWidget(
              defaultIcon: Icons.brightness_2,
              switchIcon: Icons.brightness_5,
              tooltip: ThemeViewModel.darkMode
                  ? StringHelper.getS()!.lightMode
                  : StringHelper.getS()!.darkMode,
              onPressed: () => switchDarkMode(context),
            ),
          ],
        ),
      ),

      ///内容区域
      body: Row(
        children: [
          ///宽屏布局
          Container(
            // color:
            //     ThemeViewModel.darkMode ? Color(0xFF2E2F2F) : Color(0xFFE2E2E2),
            width: displayDesktop ? 160 : 0,
            height: 10000,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(24),
                  child: AppIcon(),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TabIconNav(
                          tabs: tabs,
                          tabIndex: ValueNotifier(controller!.index),
                          onTabChanged: (index) => controller?.animateTo(index),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///更多信息
                      AnimatedSwitcherIconWidget(
                        defaultIcon: Icons.info,
                        switchIcon: Icons.info_outline,
                        tooltip: StringHelper.getS()!.moreSetting,
                        onPressed: () => showAuthorDialog(context),
                        checkTheme: true,
                      ),

                      ///暗黑模式切换
                      AnimatedSwitcherIconWidget(
                        defaultIcon: Icons.brightness_2,
                        switchIcon: Icons.brightness_5,
                        tooltip: ThemeViewModel.darkMode
                            ? StringHelper.getS()!.lightMode
                            : StringHelper.getS()!.darkMode,
                        onPressed: () => switchDarkMode(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            child: VerticalDivider(),
            visible: displayDesktop,
          ),
          Expanded(
            child: tabWidget,
            flex: 1,
          ),
        ],
      ),
    );
  }
}

///侧边icon
class TabIconNav extends StatelessWidget {
  TabIconNav({
    Key? key,
    required this.tabs,
    required this.tabIndex,
    this.onTabChanged,
  }) : super(key: key);

  final List<TabModel> tabs;
  final Function(int)? onTabChanged;
  final ValueNotifier<int> tabIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: tabs
          .map(
            (e) => SizedBox(
              // width: 120,
              // height: 44,
              child: ValueListenableBuilder<int>(
                valueListenable: tabIndex,
                builder: (context, index, child) {
                  bool isSelected = index == tabs.indexOf(e);
                  return TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(isSelected
                          ? Theme.of(context).accentColor
                          : Colors.transparent),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                          vertical: PlatformUtil.isMobile ? 10 : 15,
                          horizontal: 25,
                        ),
                      ),
                    ),
                    onPressed: () {
                      onTabChanged?.call(tabs.indexOf(e));
                      tabIndex.value = tabs.indexOf(e);
                    },
                    child: Text(
                      e.label,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : ThemeViewModel.darkMode
                                ? Colors.white.withOpacity(0.6)
                                : Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/title.png',
      width: 108,
      color: Theme.of(context).appBarTheme.iconTheme!.color,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.high,
      colorBlendMode: BlendMode.srcIn,
    );
  }
}
