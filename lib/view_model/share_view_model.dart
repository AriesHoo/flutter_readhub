import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/basis/basis_list_view_model.dart';
import 'package:flutter_readhub/basis/basis_view_model.dart';
import 'package:flutter_readhub/enum/share_card_style.dart';
import 'package:flutter_readhub/enum/share_type.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/util/share_util.dart';

///卡片分享底部ViewModel
class ShareBottomViewModel extends BasisListViewModel<ShareModel> {
  @override
  Future<List<ShareModel>> loadData() async {
    List<ShareModel> list = [];
    if (await ShareUtil.isWeChatInstall()) {
      list.add(ShareModel(ShareType.weChatFriend,
          StringHelper.getS()!.weChatFriend, 'ic_we_chat'));
      list.add(ShareModel(ShareType.weChatTimeLine,
          StringHelper.getS()!.weChatTimeLine, 'ic_we_chat_timeline'));
    }
    if (await ShareUtil.isQQInstall()) {
      list.add(ShareModel(
          ShareType.qqFriend, StringHelper.getS()!.qqFriend, 'ic_qq'));
    }
    if (await ShareUtil.isWeiBoInstall()) {
      list.add(ShareModel(ShareType.weiBoTimeLine,
          StringHelper.getS()!.weiBoTimeLine, 'ic_wei_bo'));
    }
    list.add(ShareModel(
        ShareType.copyLink, StringHelper.getS()!.copyLink, 'ic_copy_link'));
    list.add(ShareModel(
        ShareType.browser, StringHelper.getS()!.openByBrowser, 'ic_browser'));
    list.add(ShareModel(ShareType.more, StringHelper.getS()!.more, 'ic_more'));
    return list;
  }
}

///文本分享底部ViewModel
class ShareTextViewModel extends ShareBottomViewModel {
  @override
  Future<List<ShareModel>> loadData() async {
    List<ShareModel> list = [];
    list.add(
        ShareModel(ShareType.card, StringHelper.getS()!.cardShare, 'ic_card'));
    if (await ShareUtil.isWeChatInstall()) {
      list.add(ShareModel(ShareType.weChatFriend,
          StringHelper.getS()!.weChatFriend, 'ic_we_chat'));
    }
    if (await ShareUtil.isQQInstall()) {
      list.add(ShareModel(
          ShareType.qqFriend, StringHelper.getS()!.qqFriend, 'ic_qq'));
    }
    if (await ShareUtil.isWeiBoInstall()) {
      list.add(ShareModel(ShareType.weiBoTimeLine,
          StringHelper.getS()!.weiBoTimeLine, 'ic_wei_bo'));
    }
    list.add(ShareModel(
        ShareType.copyLink, StringHelper.getS()!.copyLink, 'ic_copy_link'));
    list.add(ShareModel(
        ShareType.browser, StringHelper.getS()!.openByBrowser, 'ic_browser'));
    list.add(ShareModel(ShareType.more, StringHelper.getS()!.more, 'ic_more'));
    return list;
  }
}

///图片分享底部ViewModel
class ShareImageViewModel extends ShareBottomViewModel {
  @override
  Future<List<ShareModel>> loadData() async {
    List<ShareModel> list = [];
    if (await ShareUtil.isWeChatInstall()) {
      list.add(ShareModel(ShareType.weChatFriend,
          StringHelper.getS()!.weChatFriend, 'ic_we_chat'));
      list.add(ShareModel(ShareType.weChatTimeLine,
          StringHelper.getS()!.weChatTimeLine, 'ic_we_chat_timeline'));
    }
    if (await ShareUtil.isQQInstall()) {
      list.add(ShareModel(
          ShareType.qqFriend, StringHelper.getS()!.qqFriend, 'ic_qq'));
    }
    if (await ShareUtil.isWeiBoInstall()) {
      list.add(ShareModel(ShareType.weiBoTimeLine,
          StringHelper.getS()!.weiBoTimeLine, 'ic_wei_bo'));
    }
    list.add(ShareModel(ShareType.more, StringHelper.getS()!.more, 'ic_more'));
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

  setShareCardStyle(ShareCardStyle style) {
    SpUtil.putInt('ShareCardStyle', style == ShareCardStyle.gold ? 1 : 0)!
        .then((value) {
      _shareCardStyle = SpUtil.getInt('ShareCardStyle', defValue: 0) == 1
          ? ShareCardStyle.gold
          : ShareCardStyle.app;
      setSuccess();
    });
  }
}
