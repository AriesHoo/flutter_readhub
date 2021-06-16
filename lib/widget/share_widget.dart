import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_readhub/basis/basis_highlight_view_model.dart';
import 'package:flutter_readhub/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/enum/share_type.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/view_model/share_view_model.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';

///分享底部
class ShareBottomWidget<A extends ShareBottomViewModel>
    extends StatelessWidget {
  final Function(ShareType, BuildContext context) onClick;
  final A model;
  final bool safeAreaBottom;

  const ShareBottomWidget({
    Key? key,
    required this.model,
    required this.onClick,
    this.safeAreaBottom: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasisListProviderWidget<ShareBottomViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        color: Theme.of(context).cardColor,
        child: SafeArea(
          bottom: safeAreaBottom,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShareGridWidget(
                model.list,
                onClick: onClick,
              ),
              Divider(
                height: 1,
              ),

              ///取消按钮
              CancelShare(),
            ],
          ),
        ),
      ),
    );
  }
}

///分享网格布局
class ShareGridWidget extends StatelessWidget {
  final List<ShareModel> listShare;
  final Function(ShareType, BuildContext context)? onClick;

  const ShareGridWidget(
    this.listShare, {
    Key? key,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool sizeMax = listShare.length > 8;
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        vertical: 12,
      ),
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      physics: ClampingScrollPhysics(),
      itemCount: listShare.length,
      itemBuilder: (BuildContext context, int index) {
        return BasisProviderWidget<BasisHighlightViewModel>(
          model: BasisHighlightViewModel(),
          builder: (context, highlightModel, child) => Opacity(
            opacity: highlightModel.highlight ? 0.7 : 1,
            child: Builder(
              builder: (BuildContext buildContext) => InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onHighlightChanged: highlightModel.onHighlightChanged,
                onHover: highlightModel.onHighlightChanged,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    listShare[index].icon == null
                        ? Image.asset(
                            'assets/images/share/${listShare[index].image}.png',
                            width: sizeMax ? 50 : 60,
                            height: sizeMax ? 50 : 60,
                          )
                        : Container(
                            width: sizeMax ? 50 : 60,
                            height: sizeMax ? 50 : 60,
                            child: Icon(
                              listShare[index].icon,
                              color: Colors.white,
                              size: 28,
                            ),
                            decoration: BoxDecoration(
                              ///背景
                              color: Theme.of(context).accentColor,

                              ///设置四周圆角 角度
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                          ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      listShare[index].text,
                      textScaleFactor: ThemeViewModel.textScaleFactor,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: sizeMax ? 12 : 14),
                    ),
                  ],
                ),
                onTap: () => onClick?.call(listShare[index].type, buildContext),
              ),
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        ///纵向数量
        crossAxisCount: sizeMax ? 5 : 4,

        ///主轴单个子Widget之间间距
        mainAxisSpacing: 2,

        ///交叉轴单个子Widget之间间距
        crossAxisSpacing: 2,
        childAspectRatio: 3 / 4,
        mainAxisExtent: 100,
      ),
    );
  }
}

///取消分享
class CancelShare extends StatelessWidget {
  const CancelShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasisProviderWidget<BasisHighlightViewModel>(
      model: BasisHighlightViewModel(),
      builder: (context, model, child) => Opacity(
        opacity: model.highlight ? 0.7 : 1,
        child: MaterialButton(
          height: 50,
          minWidth: double.infinity,
          onHighlightChanged: model.onHighlightChanged,
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          // color: Colors.transparent,
          splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          // hoverColor: Colors.black.withOpacity(0.025),
          // focusColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          disabledElevation: 0,
          hoverElevation: 0,
          child: Text(
            StringHelper.getS()!.cancel,
            style: Theme.of(context).textTheme.subtitle1,
            textScaleFactor: ThemeViewModel.textScaleFactor,
          ),
        ),
      ),
    );
  }
}
