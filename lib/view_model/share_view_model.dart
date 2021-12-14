import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/basis/basis_list_view_model.dart';
import 'package:flutter_readhub/basis/basis_view_model.dart';
import 'package:flutter_readhub/dialog/card_share_dialog.dart';
import 'package:flutter_readhub/dialog/text_share_dialog.dart';
import 'package:flutter_readhub/dialog/url_share_dialog.dart';
import 'package:flutter_readhub/enum/share_card_style.dart';
import 'package:flutter_readhub/enum/share_type.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/share_util.dart';

///卡片分享底部ViewModel[CardShareDialog]
class ShareBottomViewModel extends BasisListViewModel<ShareModel> {
  @override
  Future<List<ShareModel>> loadData() async {
    List<ShareModel> list = [];
    list.add(ShareModel(
      ShareType.icon,
      appString.shareCarStyle,
      '',
      icon: Icons.color_lens_rounded,
    ));
    if (await ShareUtil.isWeChatInstall()) {
      list.add(ShareModel(
        ShareType.weChatFriend,
        appString.weChatFriend,
        'ic_we_chat',
      ));
      list.add(ShareModel(
        ShareType.weChatTimeLine,
        appString.weChatTimeLine,
        'ic_we_chat_timeline',
      ));
    }
    if (await ShareUtil.isQQInstall()) {
      list.add(ShareModel(
        ShareType.qqFriend,
        appString.qqFriend,
        'ic_qq',
      ));
    }
    if (await ShareUtil.isWeiBoInstall()) {
      list.add(ShareModel(
        ShareType.weiBoTimeLine,
        appString.weiBoTimeLine,
        'ic_wei_bo',
      ));
    }
    if (await ShareUtil.isDingTalkInstall()) {
      list.add(ShareModel(
        ShareType.dingTalk,
        appString.dingTalk,
        'ic_ding_talk',
      ));
    }
    if (await ShareUtil.isWeWorkInstall()) {
      list.add(ShareModel(
        ShareType.weWork,
        appString.weWork,
        'ic_we_work',
      ));
    }
    list.add(ShareModel(
      ShareType.copyLink,
      appString.copyLink,
      'ic_copy_link',
    ));
    list.add(ShareModel(
      ShareType.browser,
      appString.openByBrowser,
      'ic_browser',
    ));
    list.add(ShareModel(
      ShareType.more,
      appString.more,
      'ic_more',
    ));
    return list;
  }
}

///url分享底部ViewModel [UrlShareDialog]
class ShareUrlViewModel extends ShareBottomViewModel {
  @override
  Future<List<ShareModel>> loadData() async {
    List<ShareModel> list = [];
    list.add(ShareModel(
      ShareType.card,
      appString.cardShare,
      'ic_card',
    ));
    if (await ShareUtil.isWeChatInstall()) {
      list.add(ShareModel(
        ShareType.weChatFriend,
        appString.weChatFriend,
        'ic_we_chat',
      ));
    }
    if (await ShareUtil.isQQInstall()) {
      list.add(ShareModel(
        ShareType.qqFriend,
        appString.qqFriend,
        'ic_qq',
      ));
    }
    if (await ShareUtil.isWeiBoInstall()) {
      list.add(ShareModel(
        ShareType.weiBoTimeLine,
        appString.weiBoTimeLine,
        'ic_wei_bo',
      ));
    }
    if (await ShareUtil.isDingTalkInstall()) {
      list.add(ShareModel(
        ShareType.dingTalk,
        appString.dingTalk,
        'ic_ding_talk',
      ));
    }
    if (await ShareUtil.isWeWorkInstall()) {
      list.add(ShareModel(
        ShareType.weWork,
        appString.weWork,
        'ic_we_work',
      ));
    }
    list.add(ShareModel(
      ShareType.copyLink,
      appString.copyLink,
      'ic_copy_link',
    ));
    list.add(ShareModel(
      ShareType.browser,
      appString.openByBrowser,
      'ic_browser',
    ));
    list.add(ShareModel(
      ShareType.more,
      appString.more,
      'ic_more',
    ));
    return list;
  }
}

///text分享底部ViewModel[TextShareDialog]
class ShareTextViewModel extends ShareBottomViewModel {
  @override
  Future<List<ShareModel>> loadData() async {
    List<ShareModel> list = [];
    if (PlatformUtil.isMacOS) {
      list.add(
        ShareModel(
          ShareType.card,
          appString.cardShare,
          'ic_card',
        ),
      );
    }
    list.add(
      ShareModel(
        ShareType.copyLink,
        appString.copyShare,
        'ic_copy_link',
      ),
    );
    list.add(
      ShareModel(
        ShareType.browser,
        appString.openByBrowser,
        'ic_browser',
      ),
    );
    if (PlatformUtil.isMacOS) {
      list.add(
        ShareModel(
          ShareType.more,
          appString.shareToApp,
          'ic_more',
        ),
      );
    }
    return list;
  }
}

///图片分享底部ViewModel
class ShareImageViewModel extends ShareBottomViewModel {
  @override
  Future<List<ShareModel>> loadData() async {
    List<ShareModel> list = [];
    if (await ShareUtil.isWeChatInstall()) {
      list.add(ShareModel(
        ShareType.weChatFriend,
        appString.weChatFriend,
        'ic_we_chat',
      ));
      list.add(ShareModel(
        ShareType.weChatTimeLine,
        appString.weChatTimeLine,
        'ic_we_chat_timeline',
      ));
    }
    if (await ShareUtil.isQQInstall()) {
      list.add(ShareModel(
        ShareType.qqFriend,
        appString.qqFriend,
        'ic_qq',
      ));
    }
    if (await ShareUtil.isWeiBoInstall()) {
      list.add(ShareModel(
        ShareType.weiBoTimeLine,
        appString.weiBoTimeLine,
        'ic_wei_bo',
      ));
    }
    if (await ShareUtil.isDingTalkInstall()) {
      list.add(ShareModel(
        ShareType.dingTalk,
        appString.dingTalk,
        'ic_ding_talk',
      ));
    }
    if (await ShareUtil.isWeWorkInstall()) {
      list.add(ShareModel(
        ShareType.weWork,
        appString.weWork,
        'ic_we_work',
      ));
    }
    list.add(ShareModel(
      ShareType.more,
      appString.more,
      'ic_more',
    ));
    return list;
  }
}

///分享卡片样式-App模式、掘金模式
class ShareCardStyleViewModel extends BasisViewModel {
  ShareCardStyle get shareCardStyle => _shareCardStyle;

  ///分享卡片样式
  ShareCardStyle _shareCardStyle = ShareCardStyle.app;

  ShareCardStyleViewModel() {
    _shareCardStyle = SpUtil.getInt('ShareCardStyle', defValue: 0) == 1
        ? ShareCardStyle.gold
        : ShareCardStyle.app;
  }

  setShareCardStyle(ShareCardStyle style) async {
    await SpUtil.putInt('ShareCardStyle', style == ShareCardStyle.gold ? 1 : 0)!
        .then((value) {
      _shareCardStyle = SpUtil.getInt('ShareCardStyle', defValue: 0) == 1
          ? ShareCardStyle.gold
          : ShareCardStyle.app;
      setSuccess();
    });
  }
}
