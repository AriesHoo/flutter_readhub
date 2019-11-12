import 'package:flutter/material.dart';
import 'package:flutter_readhub/model/list_model.dart';
import 'package:flutter_readhub/util/log_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

///分享文章详情
class ShareArticleDialog extends Dialog {
  final Data data;

  ShareArticleDialog(@required this.data);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///最上边白色圆角开始
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.only(
                left: 20,
                top: 30,
                right: 20,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ///标题
                  Text(
                    data.title,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.title.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                  ),

                  ///圆角分割线包裹内容开始
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: Theme.of(context).hintColor.withAlpha(50),
                            width: 0.5)),
                    child: Column(
                      children: <Widget>[
                        Text(
                          data.summary,
                          style: Theme.of(context).textTheme.title.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              data.getSiteName(),
                              style: Theme.of(context).textTheme.title.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            QrImage(
                              data: data.getUrl(),
                              version: QrVersions.auto,
                              size: 100.0,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  ///圆角分割线包裹内容结束

                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "由 Readhub_Flutter App 分享",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontSize: 12,
                        ),
                  )
                ],
              ),
            ),
          ),

          ///最上边白色圆角结束
          ///最底部水平分享按钮
        ],
      ),
    );
  }
}
