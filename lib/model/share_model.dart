import 'package:flutter/widgets.dart';
import 'package:flutter_readhub/enum/share_type.dart';

///分享实体
class ShareModel {
  ShareType type;
  String text;
  String image;

  ShareModel(this.type, this.text, this.image);
}

///卡片分享实体
class CardShareModel {
  final String? title;
  final String? summary;
  final String url;
  final String? fileName;
  final String? notice;
  final String? bottomNotice;
  final GlobalKey? globalKey;
  final Widget? summaryWidget;

  CardShareModel({
    this.title,
    this.summary,
    required this.url,
    this.fileName,
    this.notice,
    this.bottomNotice,
    this.globalKey,
    this.summaryWidget,
  });
}
