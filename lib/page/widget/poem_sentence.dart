import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/view_model/poem_sentence_view_model.dart';

///诗歌视图
class PoemSentence extends StatelessWidget {
  const PoemSentence({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasisProviderWidget<PoemSentenceViewModel>(
      model: PoemSentenceViewModel(),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) => model.poemSentenceModel != null
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model.poemSentenceModel!.content}',
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Wrap(
                      runSpacing: 6,
                      spacing: 6,
                      children: model.poemSentenceModel!.matchTags!
                          .map(
                            (e) => Container(
                              child: Text(
                                '$e',
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 10,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).accentColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10000),
                              ),
                            ),
                          )
                          .toList()),
                  SizedBox(
                    height: 6,
                  ),
                  TextButton(
                    onPressed: model.success ? () => model.refresh() : null,
                    child: model.loading
                        ? CupertinoActivityIndicator(
                            radius: 8,
                          )
                        : Text(
                            '换一首',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).accentColor),
                        overlayColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(0.1)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 24))),
                  )
                ],
              ),
            )
          : SizedBox(),
    );
  }
}
