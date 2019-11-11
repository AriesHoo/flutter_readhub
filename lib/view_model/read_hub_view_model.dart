import 'package:flutter_readhub/data/read_hub_repository.dart';
import 'package:flutter_readhub/model/list_model.dart';
import 'package:flutter_readhub/view_model/basis/basis_refresh_list_view_model.dart';

///获取资讯列表Model
class ReadHubListRefreshViewModel extends BasisRefreshListViewModel<Data> {
  String lastCursor;
  String url;

  ReadHubListRefreshViewModel(this.url);

  @override
  Future<List<Data>> loadData({int pageNum}) async {
    lastCursor = pageNum == 0 ? null : lastCursor;
    ListModel model = lastCursor == null
        ? await ReadHubRepository.getFirstPage(url)
        : await ReadHubRepository.getNextPage(url, lastCursor, pageSize);
    lastCursor = model.getLastCursor();
    return model.data;
  }
}
