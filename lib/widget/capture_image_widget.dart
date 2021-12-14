import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/page/widget/article_item_widget.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:flutter_readhub/widget/qr_code.dart';

///需要进行截图-RepaintBoundary包裹部分参考
///https://www.codercto.com/a/46348.html
///https://blog.csdn.net/u014449046/article/details/98471268
///https://www.cnblogs.com/wupeng88/p/10797667.html
class CaptureImageWidget extends StatefulWidget {
  final String url;
  final GlobalKey globalKey;
  final String? title;
  final String? summary;
  final Widget? summaryWidget;
  final bool showLogo;

  const CaptureImageWidget(
    this.url,
    this.globalKey, {
    this.title,
    this.summary,
    this.summaryWidget,
    this.showLogo: true,
    Key? key,
  }) : super(key: key);

  @override
  _CaptureImageWidgetState createState() => _CaptureImageWidgetState();
}

class _CaptureImageWidgetState extends State<CaptureImageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///使用SingleChildScrollView包裹RepaintBoundary才能截取完成图片
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: RepaintBoundary(
        key: widget.globalKey,
        child: Container(
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 顶部标题开始
                      ShareSlogan(
                        showLogo: widget.showLogo,
                      ),

                      /// 顶部标题结束
                      SizedBox(
                        height: TextUtil.isEmpty(widget.title) ? 0 : 12,
                      ),
                      Visibility(
                        child: Text(
                          '${widget.title}',
                          maxLines: 2,
                          textScaleFactor: ThemeViewModel.textScaleFactor,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(),
                        ),
                        visible: !TextUtil.isEmpty(widget.title),
                      ),
                      SizedBox(
                        height: TextUtil.isEmpty(widget.summary) &&
                                widget.summaryWidget == null
                            ? 0
                            : 12,
                      ),
                      Visibility(
                        visible: !TextUtil.isEmpty(widget.summary) ||
                            widget.summaryWidget != null,
                        child: widget.summaryWidget != null
                            ? widget.summaryWidget!
                            : Text(
                                '${widget.summary}',
                                textScaleFactor: ThemeViewModel.textScaleFactor,
                                strutStyle: StrutStyle(
                                  leading: 0.6,
                                ),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      letterSpacing: 1,
                                    ),
                              ),
                      ),
                    ],
                  ),
                ),
                shadowColor: Colors.purple,
                borderOnForeground: false,
                color: Theme.of(context).cardColor,
                elevation: ThemeViewModel.darkMode ? 0 : 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: ThemeViewModel.darkMode
                      ? BorderSide(
                          width: 0.5,
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          style: BorderStyle.solid,
                        )
                      : BorderSide.none,
                ),
              ),
              SizedBox(
                height: 24,
              ),

              ///二维码行开始
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 20,
                  ),

                  ///左侧二维码
                  QrCode(
                    data: widget.url,
                    size: 64,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appString.scanOrCodeForDetail,
                        textScaleFactor: ThemeViewModel.textScaleFactor,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: appString.shareForm,
                          style: Theme.of(context).textTheme.bodyText2,
                          children: [
                            TextSpan(
                              text: '「${appString.appName}」',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            TextSpan(text: 'App'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              ///二维码行结束
            ],
          ),
        ),
      ),
    );
  }
}

///分享截图slogan
class ShareSlogan extends StatelessWidget {
  final bool showLogo;

  const ShareSlogan({
    Key? key,
    this.showLogo: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        showLogo
            ? Image.asset(
                'assets/images/ic_logo_round.webp',
                width: 54,
                height: 54,
              )
            : QrCode(
                data: 'https://www.pgyer.com/ntMA',
                size: 60,
                embeddedImage: AssetImage('assets/images/ic_logo_round.webp'),
              ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appString.appName,
                textScaleFactor: ThemeViewModel.textScaleFactor,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontSize: 20),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                appString.slogan,
                textScaleFactor: ThemeViewModel.textScaleFactor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .color!
                          .withOpacity(0.5),
                      fontSize: 14,
                    ),
              ),
            ],
          ),
          flex: 1,
        ),
      ],
    );
  }
}

///需要进行截图-RepaintBoundary包裹部分参考
///https://www.codercto.com/a/46348.html
///https://blog.csdn.net/u014449046/article/details/98471268
///https://www.cnblogs.com/wupeng88/p/10797667.html
class CaptureImageAppStyleWidget extends StatelessWidget {
  final String? title;
  final String? summary;
  final String? notice;
  final String url;
  final String? bottomNotice;
  final GlobalKey globalKey;
  final Widget? summaryWidget;
  final bool showLogo;

  CaptureImageAppStyleWidget(
    this.title,
    this.summary,
    this.notice,
    this.url,
    this.bottomNotice,
    this.globalKey, {
    this.summaryWidget,
    this.showLogo: true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: RepaintBoundary(
        key: globalKey,
        child: Container(
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.only(
            left: 20,
            top: 20,
            right: 20,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ///统一分享头部
              ShareSlogan(
                showLogo: showLogo,
              ),
              SizedBox(
                height: 8,
              ),

              ///圆角分割线包裹内容开始
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 8,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),

                ///圆角线装修器
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Decorations.lineBoxBorder(
                      context,
                      left: true,
                      top: true,
                      right: true,
                      bottom: true,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ///资讯标题
                    Visibility(
                      visible: !TextUtil.isEmpty(title),
                      child: Text(
                        '$title',
                        textScaleFactor: ThemeViewModel.textScaleFactor,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: letterSpacing,
                              fontSize: 17,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: !TextUtil.isEmpty(title) ? 12 : 0,
                    ),

                    ///文章摘要
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5),
                      child: SingleChildScrollView(
                        child: summaryWidget ??
                            Visibility(
                              visible: !TextUtil.isEmpty(summary),
                              child: Text(
                                '$summary',
                                textScaleFactor: ThemeViewModel.textScaleFactor,
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(
                                    forceStrutHeight: true,
                                    height: textLineHeight,
                                    leading: leading),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      fontSize: 13,
                                      letterSpacing: letterSpacing,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .color!
                                          .withOpacity(0.8),
                                    ),
                              ),
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ///扫码提示语
                        Expanded(
                          flex: 1,
                          child: Visibility(
                            visible: !TextUtil.isEmpty(notice),
                            child: Text(
                              '$notice',
                              textScaleFactor: ThemeViewModel.textScaleFactor,
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                            ),
                          ),
                        ),

                        ///右侧二维码
                        QrCode(
                          data: url,
                          size: 64,
                        ),
                      ],
                    )
                  ],
                ),
              ),

              ///圆角分割线包裹内容结束

              SizedBox(
                height: !TextUtil.isEmpty(bottomNotice) ? 6 : 0,
              ),
              RichText(
                text: TextSpan(
                  text: appString.shareForm,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 12,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .color!
                            .withOpacity(0.6),
                      ),
                  children: [
                    TextSpan(
                      text: '「${appString.appName}」',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                          ),
                    ),
                    TextSpan(text: 'App'),
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
