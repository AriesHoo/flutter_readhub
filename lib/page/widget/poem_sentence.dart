import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/model/poem_sentence_model.dart';
import 'package:flutter_readhub/util/adaptive.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/view_model/poem_sentence_view_model.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:flutter_readhub/widget/tooltip_plus.dart';

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
          overflow:
              PlatformUtil.isWeb ? TextOverflow.fade : TextOverflow.ellipsis,
          maxLines: isDisplayDesktop ? 4 : 1,
          textScaleFactor: ThemeViewModel.textScaleFactor,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: isDisplayDesktop ? 16 : 13,
                color: isDisplayDesktop
                    ? null
                    : Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .color!
                        .withOpacity(0.8),
              ),
        );

        ///避免因系统字号变大造成异常
        LogUtil.v('textScaleFactor:${MediaQuery.of(context).textScaleFactor}');
        return Container(
          padding: isDisplayDesktop
              ? EdgeInsets.symmetric(vertical: 24, horizontal: 16)
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextUtil.isEmpty(model.poemSentenceModel!.getTooltip())
                  ? contentText
                  : TooltipPlus(
                      message: '${model.poemSentenceModel!.getTooltip()}',
                      padding: EdgeInsets.all(12),
                      child: contentText,
                      preferBelow: !isDisplayDesktop,
                      textStyle:
                          Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),

                      ///显示时间-点击其它地方消失
                      showDuration: Duration(seconds: 60),
                      margin: EdgeInsets.only(
                        bottom: isDisplayDesktop ? 12 : 84,
                        top: isDisplayDesktop ? 12 : 0,
                        left: 12,
                        right: 12,
                      ),
                      tooltip: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${model.poemSentenceModel!.title}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              '${model.poemSentenceModel!.dynastyAuthor}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            Text(
                              '${model.poemSentenceModel!.contentStr}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                            )
                          ],
                        ),
                      ),
                      decoration: ShapeDecoration(
                        shape: Decorations.lineShapeBorder(
                          context,
                          lineWidth: 0.8,
                          borderRadius: BorderRadius.circular(12),
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                        ),
                        color: Theme.of(context).cardColor.withOpacity(0.95),
                        shadows: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 24,
                          )
                        ],
                      ),
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
                      //     color: Theme.of(context).primaryColor.withOpacity(0.7),
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

              ///垂直间隔
              runSpacing: 4,

              ///水平间隔
              spacing: 4,
              children: sentenceModel.matchTags!
                  .map(
                    (e) => Container(
                      child: Text(
                        '$e',
                        textScaleFactor: ThemeViewModel.textScaleFactor,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
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
                    textScaleFactor: ThemeViewModel.textScaleFactor,
                  ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                ),
              ),
              alignment: Alignment.center,
              textStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),

              ///背景色
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.hovered) ||
                      states.contains(MaterialState.pressed)) {
                    return Theme.of(context).primaryColor;
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
                  return Theme.of(context).primaryColor;
                },
              ),

              ///hoverColor及splashColor
              overlayColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Theme.of(context).primaryColor.withOpacity(0.2);
                  }
                },
              ),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
