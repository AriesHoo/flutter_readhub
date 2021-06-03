import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/basis/basis_view_model.dart';
import 'package:flutter_readhub/data/poem_repository.dart';
import 'package:flutter_readhub/helper/sp_helper.dart';
import 'package:flutter_readhub/model/poem_sentence_model.dart';
import 'package:flutter_readhub/page/home_page.dart';

///推荐诗歌ViewModel
class PoemSentenceViewModel extends BasisViewModel {
  PoemSentenceModel? poemSentenceModel = SpHelper.getPoemSentenceModel();

  initData() async {
    await refresh(init: true);
  }

  refresh({bool init = false}) async {
    setLoading();
    try {
      poemSentenceModel = await loadData();
      setSuccess();

      ///刷新顶部
      topViewModel?.poemSentenceModel = poemSentenceModel;
    } catch (e, s) {
      ///初始化失败延迟再获取
      if (init) {
        Future.delayed(Duration(seconds: 5), () => refresh(init: true));
      } else {
        setError(e, s);
      }
      LogUtil.e('e:$e;s:$s', tag: 'PoemSentenceViewModel');
    }
  }

  ///加载数据
  Future<PoemSentenceModel> loadData() async {
    PoemSentenceModel model = await PoemRepository.getPoemSentence();
    SpHelper.setPoemSentenceModel(model);
    return model;
  }
}
