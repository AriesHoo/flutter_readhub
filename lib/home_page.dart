import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_readhub/data/read_hub_http.dart';
import 'package:flutter_readhub/generated/i18n.dart';
import 'package:flutter_readhub/model/article_model.dart';
import 'package:flutter_readhub/util/log_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/view_model/basis/basis_scroll_controller_model.dart';
import 'package:flutter_readhub/view_model/locale_model.dart';
import 'package:flutter_readhub/view_model/read_hub_view_model.dart';
import 'package:flutter_readhub/view_model/theme_model.dart';
import 'package:flutter_readhub/widget/share_article_dialog.dart';
import 'package:flutter_readhub/widget/skeleton.dart';
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
      appBar: PreferredSize(
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.brightness_5
                  : Icons.brightness_2,
            ),
            onPressed: () {
              switchDarkMode(context);
            },
          ),
          centerTitle: true,
          title: Text(
            S.of(context).appName,
            style: Theme.of(context).appBarTheme.textTheme.title.copyWith(
                  fontStyle: FontStyle.normal,
                ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                if (_scaffoldKey.currentState.isEndDrawerOpen) {
                  Navigator.pop(context);
                } else {
                  _scaffoldKey.currentState.openEndDrawer();
                }
              },
            ),
          ],
        ),
        preferredSize: Size.fromHeight(40),
      ),

      ///如此操作为了抽屉栏在上层AppBar之下否则这样做层次有点多
      body: Scaffold(
        key: _scaffoldKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 36,

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
                    (i) => ArticleItemPage(
                          url: _listUrls[i],
                        )),
              ),
            )
          ],
        ),
//        drawerScrimColor: Colors.transparent,
        endDrawer: SettingDrawer(),
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

///文章item页--最终展示效果
class ArticleItemPage extends StatefulWidget {
  final String url;

  const ArticleItemPage({Key key, this.url}) : super(key: key);

  @override
  _ArticleItemPageState createState() => _ArticleItemPageState();
}

class _ArticleItemPageState extends State<ArticleItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ArticleItemPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    LogUtil.e("movieTabPage:didUpdateWidget");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasisRefreshListProviderWidget<ReadHubListRefreshViewModel,
        ScrollTopModel>(
      ///初始化获取文章列表model
      model1: ReadHubListRefreshViewModel(widget.url),

      ///加载中占位-骨架屏-默认菊花loading
      loadingBuilder: (context, model, model2, child) {
        return SkeletonList(
          builder: (context, index) => ArticleSkeleton(),
        );
      },

      ///列表适配器
      itemBuilder: (context, model, index) => ArticleAdapter(model.list[index]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///文章适配器
class ArticleAdapter extends StatelessWidget {
  const ArticleAdapter(this.item, {Key key}) : super(key: key);
  final Data item;
  final double imgWidth = 72;
  final double imgHeight = 100;

  ///弹出分享提示框
  Future<void> showShareDialog(BuildContext context, Data data) async {
    int index = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return ShareArticleDialog(data);
      },
    );
    if (index != null) {
      print("点击了：$index");
    }
  }

  @override
  Widget build(BuildContext context) {
    item.parseTimeLong();

    ///外层Material包裹以便按下水波纹效果
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () async {
//          String url = item.getUrl();
//          LogUtil.e("mobileUrl:" + url);
//          if (await canLaunch(url)) {
//            await launch(url);
//          } else {
//            throw 'Could not launch $url';
//          }
          item.switchMaxLine();
          Provider.of<LocaleModel>(context).switchLocale(0);
        },
        onLongPress: () {
          showShareDialog(context, item);
        },

        ///Container 包裹以便设置padding margin及边界线
        child: Container(
          padding: EdgeInsets.only(left: 12, top: 12, right: 12),
//          margin: EdgeInsets.symmetric(horizontal: 12),

          ///分割线
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 8,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///标题
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 4,
              ),

              ///描述摘要
              Text(
                item.getSummary(),
                maxLines: item.maxLine ? 3 : 10000,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption.copyWith(),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.timeStr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 12,
                          ),
                    ),
                  ),
                  SmallButtonWidget(
                    onTap: () {},
                    child: Icon(IconFonts.ic_glass),
                  ),
                  SmallButtonWidget(
                    onTap: () {},
                    child: Icon(IconFonts.ic_link,size: 20,),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallButtonWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;

  const SmallButtonWidget({Key key, @required this.onTap, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: () {},
      child: Padding(
        padding: EdgeInsets.only(left: 10, top: 10,right: 4,bottom: 10),
        child: child,
      ),
    );
  }
}

///文章Item骨架屏效果
class ArticleSkeleton extends StatelessWidget {
  ArticleSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),

      ///分割线
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 8,
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///标题
          SkeletonBox(
            margin: EdgeInsets.only(top: 4, bottom: 4),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 16,
          ),

          ///摘要
          SkeletonBox(
            margin: EdgeInsets.only(bottom: 5),
            width: MediaQuery.of(context).size.width * 0.6,
            height: 10,
          ),
          SkeletonBox(
            margin: EdgeInsets.only(bottom: 5),
            width: MediaQuery.of(context).size.width * 0.4,
            height: 10,
          ),
          SkeletonBox(
            margin: EdgeInsets.only(bottom: 5),
            width: MediaQuery.of(context).size.width * 0.75,
            height: 10,
          ),
          Row(
            children: <Widget>[
              SkeletonBox(
                margin: EdgeInsets.only(bottom: 7),
                width: 40,
                height: 12,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              SkeletonBox(
                margin: EdgeInsets.only(bottom: 7),
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 10,
              ),
              SkeletonBox(
                margin: EdgeInsets.only(bottom: 7),
                width: 20,
                height: 20,
              ),
            ],
          )
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
        top: 0,
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
        ],
      ),
    );
  }
}

///颜色主题选择
class SettingThemeWidget extends StatelessWidget {
  SettingThemeWidget();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(S.of(context).choiceTheme),
      initiallyExpanded: false,
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
