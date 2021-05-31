import 'package:flutter/widgets.dart';

///tab实体
class TabModel {
  late String label;
  late String url;
  IconData? icon;

  TabModel(this.label, this.url, {this.icon});
}
