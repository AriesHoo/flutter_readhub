import 'package:flutter/widgets.dart';

///tab实体
class TabModel {
  late String label;
  late Widget page;
  Icon? icon;

  TabModel(this.label, this.page, {this.icon});
}
