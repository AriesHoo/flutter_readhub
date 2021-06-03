import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/model/poem_sentence_model.dart';

///SP相关帮助类
class SpHelper {
  ///设置上次登录账号当前为手机号
  static Future<bool?> setPoemToken(String value) async {
    return await SpUtil.putString('PoemToken', value);
  }

  ///获取上次登录账号当前为手机号
  static String getPoemToken() {
    return SpUtil.getString('PoemToken', defValue: '')!;
  }

  ///设置已获取到的推荐诗歌
  static Future<bool?> setPoemSentenceModel(PoemSentenceModel value) async {
    return await SpUtil.putObject('PoemSentenceModel', value);
  }

  ///获取最近一次缓存诗歌
  static PoemSentenceModel? getPoemSentenceModel() {
    return SpUtil.getObj<PoemSentenceModel>('PoemSentenceModel', (v) => PoemSentenceModel.fromJson(v),defValue: null);
  }
}
