import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/basis/scroll_top_model.dart';
import 'package:flutter_readhub/helper/share_helper.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/model/article_model.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/page/card_share_page.dart';
import 'package:flutter_readhub/page/web_view_page.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/view_model/article_view_model.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:flutter_readhub/widget/highlight_card_widget.dart';
import 'package:flutter_readhub/widget/skeleton.dart';

final double leading = 1;
final double textLineHeight = 0.5;
final letterSpacing = 1.0;

///文章item页--最终展示效果
class ArticleItemWidget extends StatefulWidget {
  final String url;

  const ArticleItemWidget(
    this.url, {
    Key? key,
  }) : super(key: key);

  @override
  _ArticleItemWidgetState createState() => _ArticleItemWidgetState();
}

class _ArticleItemWidgetState extends State<ArticleItemWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width - 200;
    LogUtil.v('width:$width');
    return BasisRefreshListProviderWidget<ArticleViewModel, ScrollTopModel>(
      ///初始化获取文章列表model
      model1: ArticleViewModel(widget.url),

      ///加载中占位-骨架屏-默认菊花loading
      loadingBuilder: (context, model, model2, child) {
        return SkeletonList(
          builder: (context, index) => ArticleSkeleton(),
        );
      },
      childBuilder: width >= 700
          ? (context, m1, m2) => GridView.builder(
                controller: m2.scrollController,
                addAutomaticKeepAlives: true,
                physics: ClampingScrollPhysics(),
                itemCount: m1.list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  ///纵向数量
                  crossAxisCount: width >= 1000 ? 3 : 2,

                  ///水平单个子Widget之间间距
                  mainAxisSpacing: 0.0,

                  ///垂直单个子Widget之间间距
                  crossAxisSpacing: 0.0,
                  mainAxisExtent: 180,
                ),
                itemBuilder: (context, index) => InkWell(
                  child: Material(
                    child: Hero(
                      tag: m1.list[index].getUrl(),
                      child: ArticleAdapter(m1.list[index]),
                    ),
                  ),
                ),
              )
          : null,

      ///列表适配器
      itemBuilder: (context, model, index) => Hero(
        tag: model.list[index].getUrl(),
        child: ArticleAdapter(model.list[index]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///文章Item骨架屏效果
class ArticleSkeleton extends StatelessWidget {
  ArticleSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 12),

      ///分割线
      decoration: BoxDecoration(
        border: Decorations.lineBoxBorder(context, bottom: true, width: 20),
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
            width: MediaQuery.of(context).size.width * 0.75,
            height: 10,
          ),
          SkeletonBox(
            margin: EdgeInsets.only(bottom: 5),
            width: MediaQuery.of(context).size.width * 0.6,
            height: 10,
          ),
          SkeletonBox(
            margin: EdgeInsets.only(bottom: 5),
            width: MediaQuery.of(context).size.width * 0.45,
            height: 10,
          ),
          Row(
            children: <Widget>[
              SkeletonBox(
                margin: EdgeInsets.only(bottom: 7),
                width: 36,
                height: 16,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              SkeletonBox(
                margin: EdgeInsets.only(bottom: 7),
                width: 40,
                height: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}

///文章适配器
class ArticleAdapter extends StatelessWidget {
  const ArticleAdapter(this.item, {Key? key}) : super(key: key);
  final ArticleItemModel item;

  /// 弹出其它媒体报道
  Future<void> _showNewsDialog(BuildContext context) async {
    await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).cardColor,
        builder: (BuildContext context) {
          return ListView.builder(
              itemCount: item.newsArray!.length,
              shrinkWrap: true,

              ///通过控制滚动用于手指跟随
              physics: item.newsArray!.length > 10
                  ? ClampingScrollPhysics()
                  : BouncingScrollPhysics(),
              itemBuilder: (context, index) => NewsAdapter(
                    item: item.newsArray![index],
                  ));
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget = Container(
      padding: EdgeInsets.only(top: 12),
      margin: EdgeInsets.symmetric(horizontal: 12),

      ///分割线
      decoration: BoxDecoration(
        border: Decorations.lineBoxBorder(context, bottom: true),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///标题
          Text(
            item.title!,
            textScaleFactor: ThemeViewModel.articleTextScaleFactor,
            maxLines: 1,
            strutStyle: StrutStyle(
              forceStrutHeight: true,
              height: textLineHeight,
              leading: leading,
            ),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: letterSpacing,
                ),
          ),
          SizedBox(
            height: 6,
          ),

          ///描述摘要
          Text(
            item.getSummary(),
            textScaleFactor: ThemeViewModel.articleTextScaleFactor,
            maxLines: PlatformUtil.isMobile
                ? item.maxLine
                    ? 3
                    : 10000
                : 3,
            overflow: TextOverflow.ellipsis,
            strutStyle: StrutStyle(
                forceStrutHeight: true,
                height: textLineHeight,
                leading: leading),
            style: Theme.of(context).textTheme.caption!.copyWith(
                letterSpacing: letterSpacing,
                color: Theme.of(context)
                    .textTheme
                    .headline6!
                    .color!
                    .withOpacity(0.8)),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  item.getTimeStr(),
                  textScaleFactor: ThemeViewModel.articleTextScaleFactor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 12,
                      ),
                ),
              ),

              ///分享
              SmallButtonWidget(
                onTap: () => _shareArticle(context),
                tooltip: StringHelper.getS()!.share,
                child: Icon(
                  Icons.share,
                  size: 20,
                ),
              ),

              ///更多链接
              item.showLink()
                  ? SmallButtonWidget(
                      onTap: () => _showNewsDialog(context),
                      tooltip: StringHelper.getS()!.more,
                      child: Icon(
                        IconFonts.ic_link,
                        size: 20,
                      ),
                    )
                  : SizedBox(),

              ///查看详情web
              SmallButtonWidget(
                onTap: () =>
                    WebViewPage.start(context, item.getCardShareModel()),
                tooltip: StringHelper.getS()!.openDetail,
                child: Icon(IconFonts.ic_glass),
              ),
            ],
          ),
        ],
      ),
    );

    ///外层Material包裹以便按下水波纹效果
    return Material(
      color: Theme.of(context).cardColor,
      child: HighlightCardWidget(
        ///Container 包裹以便设置padding margin及边界线
        builder: (context, model) => childWidget,
      ),
    );
  }

  ///长按
  _onLongPress(BuildContext context) {
    CardSharePage.show(
      context,
      item.getCardShareModel(),
    );
  }

  ///显示分享
  _shareArticle(BuildContext context) {
    if (PlatformUtil.isMobile) {
      _onLongPress(context);
    } else {
      ShareHelper.singleton
          .shareTextToClipboard(item.getCardShareModel().text!);
    }
  }
}

///ArticleAdapter 打开连接及关联报道Button
class SmallButtonWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;
  final String tooltip;

  const SmallButtonWidget({
    Key? key,
    required this.onTap,
    required this.child,
    required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}

///查看更多新闻适配器
class NewsAdapter extends StatelessWidget {
  final NewsArray item;

  const NewsAdapter({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () => WebViewPage.start(
          context,
          CardShareModel(
            title: item.title,
            text:
                "${StringHelper.getS()!.saveImageShareTip} 资讯 「${item.title}」 链接： ${item.getUrl()}",
            summary: item.getSummary(),
            notice: item.getScanNote(),
            url: item.getUrl(),
            bottomNotice: StringHelper.getS()!.saveImageShareTip,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Decorations.lineBoxBorder(context, bottom: true),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ///顶部标题
              Text(
                item.title!,
                textScaleFactor: ThemeViewModel.textScaleFactor,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 14,
                    ),
              ),
              SizedBox(
                height: 6,
              ),

              ///水平媒体名及发布时间
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.siteName!,
                      textScaleFactor: ThemeViewModel.textScaleFactor,
                      style: Theme.of(context).textTheme.title!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                    ),
                  ),
                  Text(
                    item.parseTimeLong()!,
                    textScaleFactor: ThemeViewModel.textScaleFactor,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
