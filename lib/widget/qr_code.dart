import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

///二维码生成
class QrCode extends StatelessWidget {
  final String data;
  final double? size;
  final ImageProvider? embeddedImage;
  final Size? embeddedImageSize;

  const QrCode({
    Key? key,
    required this.data,
    this.size,
    this.embeddedImage,
    this.embeddedImageSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: data,
      padding: EdgeInsets.all(1),
      version: QrVersions.auto,
      size: size,
      embeddedImage: embeddedImage,
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: embeddedImageSize,
      ),
      foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}
