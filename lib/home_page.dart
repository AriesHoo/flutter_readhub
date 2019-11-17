import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_readhub/data/article_http.dart';
import 'package:flutter_readhub/generated/i18n.dart';
import 'package:flutter_readhub/util/log_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/theme_model.dart';
import 'package:flutter_readhub/widget/article_item_widget.dart';
import 'package:flutter_readhub/widget/home_drawer_widget.dart';
import 'package:provider/provider.dart';

///主页面
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _listUrls = [
    ArticleHttp.API_TOPIC,
    ArticleHttp.API_NEWS,
    ArticleHttp.API_TECH_NEWS,
    ArticleHttp.API_BLOCK_CHAIN
  ];
  var _listTab = ["热门话题", "科技动态", "开发者资讯", "区块链"];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: _listTab.length, vsync: this);

    ///添加监听用于监控前后台转换
    WidgetsBinding.instance.addObserver(this);
    LogUtil.e("_MoviePageState_initState");
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).cardColor,
      appBar: PreferredSize(
        child: AppBar(
          centerTitle: true,
          title: Text(
            S.of(context).appName,
            style: Theme.of(context).appBarTheme.textTheme.title.copyWith(
                  fontStyle: FontStyle.normal,
                ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.brightness_5
                    : Icons.brightness_2,
              ),
              onPressed: () {
                switchDarkMode(context);
              },
            ),
          ],
        ),
        preferredSize: Size.fromHeight(40),
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
            child: TabBarWidget(
              labels: _listTab,
              controller: _tabController,
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
                      )),
            ),
          )
        ],
      ),

      ///侧边抽屉栏
      drawer: HomeDrawerWidget(),
    );
  }
}

///TabBar效果
class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    Key key,
    this.labels,
    this.controller,
  }) : super(key: key);
  final List labels;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,

      tabs: List.generate(labels.length, (i) => Tab(text: labels[i])),

      ///不自动滚动则均分屏幕宽度
      isScrollable: false,

      ///指示器高度
      indicatorWeight: 1.5,

      ///指示器y颜色
      indicatorColor:
          ThemeModel.darkMode ? Colors.white : Theme.of(context).accentColor,

      ///指示器样式-根据label宽度
      indicatorSize: TabBarIndicatorSize.label,

      ///选中label颜色
      labelColor:
          ThemeModel.darkMode ? Colors.white : Theme.of(context).accentColor,

      ///未选择label颜色
      unselectedLabelColor: Theme.of(context).hintColor,
    );
  }
}
