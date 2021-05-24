import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_readhub/helper/path_helper.dart';
import 'package:flutter_readhub/helper/permission_helper.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/util/dialog_util.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

///保存图片到本地存储
class SaveImageHelper {
  ///已保存图片的路径
  String? _fileImage;
  Uint8List? _pngBytes;
  GlobalKey? _globalKey;
  bool? _darkModel;

  Future<String> getImagePath(String imageName) async {
    File fileImage = await PathHelper.getShareImage()
        .then((value) => File('$value/$imageName'));
    return fileImage.path;
  }

  ///保存图片
  Future<String?> saveImage(
      BuildContext context, GlobalKey globalKey, String imageName) async {
    ///key相等才有可能是同一图像
    ///明暗主题相同
    if (globalKey == _globalKey &&
        ThemeViewModel.darkMode == _darkModel &&
        _fileImage != null &&
        _fileImage!.isNotEmpty &&
        File(_fileImage!).existsSync()) {
      ///已经存在
      return _fileImage!;
    }
    _globalKey = globalKey;
    _darkModel = ThemeViewModel.darkMode;
    _fileImage = null;

    ///直接获取读写文件权限
    if (!await PermissionHelper.checkStoragePermission()) {
      DialogUtil.showAlertDialog(
        context,
        title: PlatformUtil.isIOS ? StringHelper.getS()!.dialogTitle : null,
        content: StringHelper.getS()!.shareImageNeedInvite +
            (PlatformUtil.isIOS
                ? StringHelper.getS()!.photo
                : StringHelper.getS()!.fileStorage),
        cancel: StringHelper.getS()!.noPermission,
        ensure: StringHelper.getS()!.goPermission,
      ).then((value) {
        if (value == 1) {
          openAppSettings();
        }
      });
      return null;
    }
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ///弹框宽度与屏幕宽度比值避免截图出来比预览更大
    ///分辨率通过获取设备的devicePixelRatio以达到清晰度良好
    var image = await boundary.toImage(
        pixelRatio: (MediaQuery.of(context).devicePixelRatio));

    ///转二进制
    ByteData byteData = (await image.toByteData(format: ImageByteFormat.png))!;

    ///图片数据
    _pngBytes = byteData.buffer.asUint8List();

    ///保存图片到系统图库
    File saveFile = File(await getImagePath(imageName));
    LogUtil.v('saveFile:${saveFile.path}');
    bool exist = saveFile.existsSync() && saveFile.lengthSync() > 0;
    if (!exist) {
      if (!saveFile.existsSync()) {
        await saveFile.create();
      }
      File file = await saveFile.writeAsBytes(_pngBytes!);
      exist = await file.exists();
    }
    if (exist) {
      _fileImage = saveFile.absolute.path;
      return saveImage(context, globalKey, imageName);
    }
    return null;
  }
}
