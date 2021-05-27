import 'package:flutter/material.dart';

///KeepAliveWidget-可保存不被回收Widget
class KeepAliveWidget extends StatefulWidget {
  final Widget child;

  const KeepAliveWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
