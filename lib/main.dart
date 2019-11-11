import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_readhub/data/read_hub_http.dart';
import 'package:flutter_readhub/data/read_hub_repository.dart';
import 'package:flutter_readhub/model/list_model.dart';
import 'package:flutter_readhub/router_manger.dart';
import 'package:flutter_readhub/util/log_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/read_hub_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'generated/i18n.dart';
import 'view_model/basis/basis_provider_widget.dart';
import 'view_model/basis/basis_scroll_controller_model.dart';
import 'view_model/locale_model.dart';
import 'view_model/theme_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'widget/skeleton.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///OKToast初始化以便全局使用context
    return OKToast(
      ///Provider 以便主题及国际化语言
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeModel>.value(value: ThemeModel()),
          ChangeNotifierProvider<LocaleModel>.value(value: LocaleModel()),
        ],
        child: Consumer2<ThemeModel, LocaleModel>(
          builder: (context, themeModel, localeModel, child) => AppWidget(
            themeModel: themeModel,
            localeModel: localeModel,
          ),
        ),
      ),
    );
  }
}

///App
class AppWidget extends StatelessWidget {
  final ThemeModel themeModel;
  final LocaleModel localeModel;

  const AppWidget({
    Key key,
    this.themeModel,
    this.localeModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///全局主题配置
      theme: themeModel.themeData(),
      darkTheme: themeModel.themeData(platformDarkMode: true),

      ///去掉右上顶部debug标签
      debugShowCheckedModeBanner: false,

      ///国际化语言
      locale: localeModel.locale,
      localizationsDelegates: [
        S.delegate,

        ///下拉刷新库国际化配置
        RefreshLocalizations.delegate,

        ///不配置该项会在EditField点击弹出复制粘贴工具时抛异常 The getter 'cutButtonLabel' was called on null.
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,

      ///配置页面路由
      onGenerateRoute: Router.generateRoute,

      ///主页
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _listUrls = [
    ReadHubHttp.API_TOPIC,
    ReadHubHttp.API_NEWS,
    ReadHubHttp.API_TECH_NEWS,
    ReadHubHttp.API_BLOCK_CHAIN
  ];
  var _listTab = ["热门话题", "科技动态", "开发者资讯", "区块链"];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: _listTab.length, vsync: this);
    LogUtil.e("_MoviePageState_initState");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Text(
          S.of(context).appName,
          style: Theme.of(context).appBarTheme.textTheme.title.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
        title: Text(
          S.of(context).appName,
          style: Theme.of(context).appBarTheme.textTheme.title.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            ///添加该属性去掉Tab按下水波纹效果
            color: Theme.of(context).appBarTheme.color,
            child: TabBarWidget(
              labels: _listTab,
              controller: _tabController,
            ),
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                  _listTab.length,
                  (i) => MovieItemPage(
                        url: _listUrls[i],
                      )),
            ),
          )
        ],
      ),
      drawerScrimColor: Colors.transparent,
      endDrawer: SettingDrawer(),
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
      tabs: List.generate(
          labels.length,
          (i) => Tab(
                text: labels[i],
              )),

      ///超过长度自动滚动
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

///电影item页--最终展示效果
class MovieItemPage extends StatefulWidget {
  final String url;

  const MovieItemPage({Key key, this.url}) : super(key: key);

  @override
  _MovieItemPageState createState() => _MovieItemPageState();
}

class _MovieItemPageState extends State<MovieItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(MovieItemPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    LogUtil.e("movieTabPage:didUpdateWidget");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasisRefreshListProviderWidget<ReadHubListRefreshViewModel,
        ScrollTopModel>(
      ///初始化获取电影列表model
      model1: ReadHubListRefreshViewModel(widget.url),

      ///加载中占位-骨架屏-默认菊花loading
      loadingBuilder: (context, model, model2, child) {
        return SkeletonList(
          builder: (context, index) => MovieSkeleton(),
        );
      },

      ///列表适配器
      itemBuilder: (context, model, index) => MovieAdapter(model.list[index]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///电影适配器
class MovieAdapter extends StatelessWidget {
  const MovieAdapter(this.item, {Key key}) : super(key: key);
  final Data item;
  final double imgWidth = 72;
  final double imgHeight = 100;

  @override
  Widget build(BuildContext context) {
    ///外层Material包裹以便按下水波纹效果
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () {},

        ///Container 包裹以便设置padding margin及边界线
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 12),

          ///分割线
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: Theme.of(context).hintColor.withOpacity(0.2),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 12,
              ),

              ///右边文字-设置flex=1宽度占用剩余部分全部以便其中文字自动换行
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ///右边文字描述
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      S.of(context).movieGenres + item.summary,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///电影骨架屏效果
class MovieSkeleton extends StatelessWidget {
  final double imgWidth = 72;
  final double imgHeight = 100;

  MovieSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 12),

      ///分割线
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Theme.of(context).hintColor.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ///左边图片
          SkeletonBox(
            borderRadius: BorderRadius.circular(1),
            width: imgWidth,
            height: imgHeight,
          ),
          SizedBox(
            width: 12,
          ),

          ///右边文字-设置flex=1宽度占用剩余部分全部以便其中文字自动换行
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ///右边文字描述
                SkeletonBox(
                  margin: EdgeInsets.only(bottom: 7, top: 4),
                  width: 140,
                  height: 14,
                ),
                SkeletonBox(
                  margin: EdgeInsets.only(bottom: 7),
                  width: 100,
                  height: 12,
                ),
                SkeletonBox(
                  margin: EdgeInsets.only(bottom: 7),
                  width: 66,
                  height: 12,
                ),
                SkeletonBox(
                  margin: EdgeInsets.only(bottom: 7),
                  width: 160,
                  height: 12,
                ),
                SkeletonBox(
                  margin: EdgeInsets.only(bottom: 7),
                  width: 240,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///设置功能抽屉栏
class SettingDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      ///留出状态栏+appBar高度56+24
      margin: EdgeInsets.only(
        top: 80,
      ),
      height: double.infinity,
      width: 240,
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Material(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 16, right: 4),
                    title: Text(S.of(context).settingHideFloatingButton),
                    trailing: Checkbox(
                      activeColor: Theme.of(context).accentColor,
                      value: ThemeModel.hideFloatingButton,
                      onChanged: (checked) {
                        Provider.of<ThemeModel>(context)
                            .switchHideFloatingButton(checked);
                      },
                    ),
                    onTap: () {
                      Provider.of<ThemeModel>(context).switchHideFloatingButton(
                          !ThemeModel.hideFloatingButton);
                    },
                  ),
                ),
                SettingThemeWidget(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Theme.of(context).brightness == Brightness.light
                      ? Icons.brightness_7
                      : Icons.brightness_2,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  switchDarkMode(context);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.info,
                  color: Theme.of(context).appBarTheme.iconTheme.color,
                ),
                onPressed: () {
                  switchDarkMode(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void switchDarkMode(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      ToastUtil.show("检测到系统为暗黑模式,已为你自动切换");
    } else {
      Provider.of<ThemeModel>(context).switchTheme(
          userDarkMode: Theme.of(context).brightness == Brightness.light);
    }
  }
}

///颜色主题选择
class SettingThemeWidget extends StatelessWidget {
  SettingThemeWidget();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(S.of(context).choiceTheme),
      initiallyExpanded: true,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: <Widget>[
              ...ThemeModel.themeValueList.map((color) {
                int index = ThemeModel.themeValueList.indexOf(color);
                return Material(
                  borderRadius: BorderRadius.circular(2),
                  color: color,
                  child: InkWell(
                    onTap: () {
                      var model = Provider.of<ThemeModel>(context);
                      var brightness = Theme.of(context).brightness;
                      model.switchTheme(color: color);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Text(
                          ThemeModel.themeName(context, i: index),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
