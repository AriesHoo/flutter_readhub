import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/model/poem_sentence_model.dart';
import 'package:flutter_readhub/util/adaptive.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/view_model/poem_sentence_view_model.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';

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
                fontWeight: FontWeight.bold,
                fontSize: isDisplayDesktop ? null : 14,
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
                          Theme.of(context).tooltipTheme.textStyle!.copyWith(
                                fontSize: 14,
                              ),
                      showDuration: Duration(seconds: 10),
                      decoration: BoxDecoration(
                        color: (ThemeViewModel.darkMode
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
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
                      ),
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
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                    // side: BorderSide(
                    //   color: Theme.of(context).accentColor,
                    //   width: 0.7,
                    // ),
                  ),
                ),
                alignment: Alignment.center,
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).accentColor),
                overlayColor:
                    MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 24))),
          ),
        ],
      ),
    );
  }
}
