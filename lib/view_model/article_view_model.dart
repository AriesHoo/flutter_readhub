import 'package:flustars/flustars.dart';
import 'package:flutter_readhub/basis/basis_refresh_list_view_model.dart';
import 'package:flutter_readhub/data/article_repository.dart';
import 'package:flutter_readhub/model/article_model.dart';

///获取资讯列表Model
class ArticleViewModel extends BasisRefreshListViewModel<ArticleItemModel> {
  String? lastCursor;
  String? url;

  ArticleViewModel(this.url);

  @override
  Future<List<ArticleItemModel>?> loadData({int? pageNum}) async {
    ///第一页将游标重置
    lastCursor = pageNum == 0 ? null : lastCursor;
    ArticleModel model = await ArticleRepository.getArticleList(url!,
        lastCursor: lastCursor, pageSize: pageSize);
    lastCursor = model.getLastCursor();


    LogUtil.v('lastCursor:$lastCursor');
    return model.data;
  }
}
