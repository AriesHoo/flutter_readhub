import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_readhub/generated/i18n.dart';
import 'package:flutter_readhub/model/list_model.dart';
import 'package:flutter_readhub/util/log_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

///分享文章详情
class ShareArticleDialog extends Dialog {
  final Data data;

  ShareArticleDialog(this.data);

  final GlobalKey _globalKey = GlobalKey();

  String fileImage;

  ///保存图片
  _saveImage(BuildContext context, {bool share: false}) async {
    if (fileImage != null && fileImage.isNotEmpty) {
      if (share) {
        ToastUtil.show("share");
      } else {
        ToastUtil.show("保存成功");
      }
      return;
    }

    ///检查权限
//    PermissionStatus permission =  await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
//    if(permission==PermissionStatus.denied){
//      ToastUtil.show("denied");
//    }else if(permission==PermissionStatus.disabled){
//      ToastUtil.show("disabled");
//    }else if(permission==PermissionStatus.restricted){
//      ToastUtil.show("restricted");
//    }else if(permission==PermissionStatus.granted){
//      ToastUtil.show("granted");
//    }
    /// 在这里添加需要的权限
    Map<PermissionGroup, PermissionStatus> map =
        await PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage,
    ]);
    PermissionStatus permission = map[PermissionGroup.storage];
    if (permission != PermissionStatus.granted) {
      ToastUtil.show("denied");
      return;
    }
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    var image = await boundary.toImage();

    ///转二进制
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);

    ///图片数据
    Uint8List pngBytes = byteData.buffer.asUint8List();

    ///保存图片到系统图库
    String result = await ImageGallerySaver.saveImage(pngBytes);
    if(result!=null&&result.isNotEmpty){
      fileImage = result;
      _saveImage(context,share: share);
      return;
    }
    ToastUtil.show("保存失败");
    LogUtil.e("result:" + result);
//    String appDocPath = await getTemporaryDirectory();
//    final imageFile = File(path.join(appDocPath, 'dart.png')); // 保存在应用文件夹内
//    await imageFile.writeAsBytes(finalPngBytes);
  }

  @override
  Widget build(BuildContext context) {
    ///最外层包裹设置距离屏幕边距
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///最上边白色圆角开始
          ShareWidget(data, _globalKey),

          ///最上边白色圆角结束
          SizedBox(
            height: 20,
          ),

          ///最底部水平分享按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                elevation: 0,
                tooltip: S.of(context).share,
                backgroundColor: Theme.of(context).accentColor,
                splashColor: Colors.white.withAlpha(50),
                child: Icon(Icons.share),
                onPressed: () => _saveImage(context, share: true),
              ),
              SizedBox(
                width: 20,
              ),
              FloatingActionButton(
                elevation: 0,
                tooltip: S.of(context).downloadImage,
                backgroundColor: Colors.red,
                splashColor: Colors.white.withAlpha(50),
                child: Icon(Icons.file_download),
                onPressed: () => _saveImage(context),
              ),
            ],
          )
        ],
      ),
    );
  }
}

///需要进行截图-RepaintBoundary包裹部分参考
///https://www.codercto.com/a/46348.html
///https://blog.csdn.net/u014449046/article/details/98471268
///https://www.cnblogs.com/wupeng88/p/10797667.html
class ShareWidget extends StatelessWidget {
  final Data data;
  final GlobalKey globalKey;

  ShareWidget(this.data, this.globalKey);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.only(
            left: 20,
            top: 24,
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

                ///圆角线装修器
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: Theme.of(context).hintColor.withAlpha(50),
                        width: 0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ///文章摘要
                    Text(
                      data.getSummary(),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ///扫码提示语
                        Expanded(
                          flex: 1,
                          child: Text(
                            data.getScanNote(),
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.title.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                          ),
                        ),

                        ///右侧二维码
                        QrImage(
                          data: data.getUrl(),
                          version: QrVersions.auto,
                          size: 80,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),

              ///圆角分割线包裹内容结束

              SizedBox(
                height: 10,
              ),
              Text(
                "由 Readhub_Flutter App 分享",
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: 11,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
