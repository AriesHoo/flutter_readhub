import 'package:flutter_readhub/data/read_hub_repository.dart';
import 'package:flutter_readhub/model/article_model.dart';
import 'package:flutter_readhub/view_model/basis/basis_refresh_list_view_model.dart';

///获取资讯列表Model
class ReadHubListRefreshViewModel extends BasisRefreshListViewModel<Data> {
  String lastCursor;
  String url;

  ReadHubListRefreshViewModel(this.url);

  @override
  Future<List<Data>> loadData({int pageNum}) async {
    ///第一页将游标重置
    lastCursor = pageNum == 0 ? null : lastCursor;
    ArticleModel model = await ReadHubRepository.getArticleList(url,
        lastCursor: lastCursor, pageSize: pageSize);
    lastCursor = model.getLastCursor();
    return model.data;
  }
}
