import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/model/poem_sentence_model.dart';
import 'package:flutter_readhub/util/adaptive.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/view_model/poem_sentence_view_model.dart';

///诗歌视图-左侧tab下
class PoemSentence extends StatelessWidget {
  const PoemSentence({
    Key? key,
    this.onModelReady,
  }) : super(key: key);

  final Function(PoemSentenceViewModel)? onModelReady;

  @override
  Widget build(BuildContext context) {
    return BasisProviderWidget<PoemSentenceViewModel>(
      model: PoemSentenceViewModel(),
      onModelReady: (model) {
        model.initData();
        onModelReady?.call(model);
      },
      builder: (context, model, child) {
        if (model.poemSentenceModel == null) {
          return SizedBox();
        }

        ///诗歌content
        Widget contentText = Text(
          '${model.poemSentenceModel!.content}',

          ///浏览器...显示异常
          overflow: PlatformUtil.isBrowser
              ? TextOverflow.fade
              : TextOverflow.ellipsis,
          maxLines: isDisplayDesktop ? 4 : 1,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: isDisplayDesktop ? 15 : 12,
                color: isDisplayDesktop
                    ? null
                    : Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .color!
                        .withOpacity(0.8),
              ),
        );
        return Container(
          padding: isDisplayDesktop
              ? EdgeInsets.symmetric(vertical: 24, horizontal: 16)
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextUtil.isEmpty(model.poemSentenceModel!.getTooltip())
                  ? contentText
                  : Tooltip(
                      message: '${model.poemSentenceModel!.getTooltip()}',
                      padding: EdgeInsets.all(12),
                      child: contentText,
                      preferBelow: !isDisplayDesktop,
                      textStyle:
                          Theme.of(context).textTheme.bodyText2!.copyWith(
                              // fontSize: 14,
                              // fontWeight: FontWeight.normal,
                              ),

                      ///显示时间-点击其它地方消失
                      showDuration: Duration(seconds: 30),
                      decoration: ShapeDecoration(
                          shape: Decorations.lineShapeBorder(
                            context,
                            lineWidth: 0.8,
                            borderRadius: BorderRadius.circular(12),
                            color:
                                Theme.of(context).accentColor.withOpacity(0.8),
                          ),
                          color: Theme.of(context).cardColor.withOpacity(0.95),
                          shadows: [
                            BoxShadow(
                              color: Theme.of(context).accentColor,
                              offset: Offset(1.0, 1.0),
                              blurRadius: 16,
                            )
                          ]),
                      // decoration: BoxDecoration(
                      //   color: (ThemeViewModel.darkMode
                      //           ? Colors.white
                      //           : Colors.black)
                      //       .withOpacity(0.9),
                      //   borderRadius: BorderRadius.all(Radius.circular(6)),

                      ///渐变色
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.red,
                      //     Colors.orange,
                      //     Colors.yellow,
                      //     Colors.green,
                      //     Colors.cyan,
                      //     Colors.blue,
                      //     Colors.purple,
                      //   ],
                      // ),
                      // boxShadow: [
                      //   //阴影
                      //   BoxShadow(
                      //     color: Theme.of(context).accentColor.withOpacity(0.7),
                      //     offset: Offset(1.0, 1.0),
                      //     blurRadius: 6.0,
                      //   )
                      // ],
                      // ),
                    ),
              _extendWidget(context, model.poemSentenceModel!, model),
            ],
          ),
        );
      },
    );
  }

  ///额外Widget
  Widget _extendWidget(BuildContext context, PoemSentenceModel sentenceModel,
      PoemSentenceViewModel model) {
    return Visibility(
      visible: isDisplayDesktop,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 6,
          ),

          ///诗歌tag
          Wrap(
              runSpacing: 6,
              spacing: 6,
              children: sentenceModel.matchTags!
                  .map(
                    (e) => Container(
                      child: Text(
                        '$e',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                          width: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(10000),
                      ),
                    ),
                  )
                  .toList()),
          SizedBox(
            height: 6,
          ),

          ///切歌
          TextButton(
            onPressed: model.success ? () => model.refresh() : null,
            child: model.loading
                ? CupertinoActivityIndicator(
                    radius: 6,
                  )
                : Text(
                    '换一首',
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                    side: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 1,
                    ),
                  ),
                ),
                alignment: Alignment.center,

                ///背景色
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.pressed)) {
                      return Theme.of(context).accentColor;
                    }
                    return Colors.transparent;
                  },
                ),

                ///前景色--TextColor
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    ///鼠标悬浮及手指按下
                    if (states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.pressed)) {
                      return Colors.white;
                    }
                    return Theme.of(context).accentColor;
                  },
                ),

                ///hoverColor及splashColor
                overlayColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black.withOpacity(0.2);
                    }
                  },
                ),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 24))),
          ),
        ],
      ),
    );
  }
}
