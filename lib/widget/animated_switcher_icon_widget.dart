import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';

///添加切换动画IconButton
class AnimatedSwitcherIconWidget extends StatefulWidget {
  final IconData? defaultIcon;
  final IconData? switchIcon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Duration duration;
  final bool checkTheme;

  const AnimatedSwitcherIconWidget({
    Key? key,
    this.defaultIcon,
    this.switchIcon,
    this.tooltip,
    this.onPressed,
    this.duration = const Duration(milliseconds: 500),
    this.checkTheme: false,
  }) : super(key: key);

  @override
  _AnimatedSwitcherIconWidgetState createState() =>
      _AnimatedSwitcherIconWidgetState();
}

class _AnimatedSwitcherIconWidgetState
    extends State<AnimatedSwitcherIconWidget> {
  IconData? _actionIcon;

  _AnimatedSwitcherIconWidgetState();

  @override
  void initState() {
    super.initState();
    _actionIcon = widget.defaultIcon;
  }

  DateTime? _lastSetSystemUiAt;

  @override
  void didUpdateWidget(AnimatedSwitcherIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.checkTheme) {
      return;
    }

    ///更新UI--在深色暗色模式切换时候也会触发因ThemeData无NavigationBar相关主题配置故采用该方法迂回处理
    if (_lastSetSystemUiAt == null ||
        DateTime.now().difference(_lastSetSystemUiAt!) >
            Duration(milliseconds: 1000)) {
      ///两次点击间隔超过阈值则重新计时
      _lastSetSystemUiAt = DateTime.now();
      LogUtil.v('设置系统栏颜色');
      ThemeViewModel.setSystemBarTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, anim) {
        return ScaleTransition(child: child, scale: anim);
      },
      duration: widget.duration,
      child: IconButton(
        tooltip: widget.tooltip,
        key: ValueKey(_actionIcon =
            ThemeViewModel.darkMode ? widget.switchIcon : widget.defaultIcon),
        icon: Icon(_actionIcon),
        onPressed: widget.onPressed,
      ),
    );
  }
}
