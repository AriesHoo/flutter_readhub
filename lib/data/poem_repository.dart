import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/data/poem_http.dart';
import 'package:flutter_readhub/helper/sp_helper.dart';
import 'package:flutter_readhub/model/poem_sentence_model.dart';
import 'package:flutter_readhub/util/platform_util.dart';

///诗歌
class PoemRepository {
  ///获取token
  static Future<String> getPoemToken() async {
    Response response;
    if (!PlatformUtil.isBrowser) {
      response = await http.get(
        'token',
      );
    } else {
      response = await Dio().get('https://v2.jinrishici.com/token');
    }
    String token = response.data['data'];
    if (!TextUtil.isEmpty(token)) {
      SpHelper.setPoemToken(token);
    }
    return token;
  }

  ///获取推荐诗歌
  static Future<PoemSentenceModel> getPoemSentence() async {
    Response response;

    ///无token
    if (TextUtil.isEmpty(SpHelper.getPoemToken())) {
      await getPoemToken();
    }
    if (!PlatformUtil.isBrowser) {
      response = await http.get(
        'sentence',
      );
    } else {
      Map<String, dynamic> headers = LinkedHashMap();
      if (!TextUtil.isEmpty(SpHelper.getPoemToken())) {
        headers.putIfAbsent('X-User-Token', () => SpHelper.getPoemToken());
      }
      response = await Dio().get(
        'https://v2.jinrishici.com/sentence',
        options: Options(
          headers: headers,
        ),
      );
    }
    return PoemSentenceModel.fromJson(response.data['data']);
  }
}
