import 'package:fun_flutter/model/article.dart';
import 'package:fun_flutter/model/banner.dart';
import 'package:fun_flutter/service/wan_android_repository.dart';
import 'package:fun_flutter/view_model/base/view_state_list_refresh_model.dart';

class HomeViewModel extends ViewStateRefreshListModel {
  List<Banner> _banners;
  List<Article> _topArticles;

  List<Banner> get banners => _banners;

  List<Article> get topArticles => _topArticles;

  @override
  Future<List> loadData({int pageNum}) async {
    List<Future> futures = [];
    if (pageNum == ViewStateRefreshListModel.pageNumFirst) {
      futures.add(WanAndroidRepository.fetchBanners());
      futures.add(WanAndroidRepository.fetchTopArticles());
    }
    futures.add(WanAndroidRepository.fetchArticles(pageNum));
    var result = await Future.wait(futures);
    if (pageNum == ViewStateRefreshListModel.pageNumFirst) {
      _banners = result[0];
      _topArticles = result[1];
      return result[2];
    } else {
      return result[0];
    }
  }

//  @override
//  onCompleted(List data) {
//    // TODO: implement onCompleted
//    return super.onCompleted(data);
//  }
//
}
