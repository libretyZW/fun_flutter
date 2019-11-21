import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fun_flutter/generated/i18n.dart';
import 'package:fun_flutter/model/article.dart';
import 'package:fun_flutter/ui/help/refresh_helper.dart';
import 'package:fun_flutter/ui/widget/animated_provider.dart';
import 'package:fun_flutter/ui/widget/article_list_Item.dart';
import 'package:fun_flutter/ui/widget/article_skeleton.dart';
import 'package:fun_flutter/ui/widget/banner_image.dart';
import 'package:fun_flutter/ui/widget/skeleton.dart';
import 'package:fun_flutter/utils/status_bar_utils.dart';
import 'package:fun_flutter/view_model/base/provider_widget.dart';
import 'package:fun_flutter/view_model/base/view_state_widget.dart';
import 'package:fun_flutter/view_model/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const double kHomeRefreshHeight = 180.0;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var bannerHeight = MediaQuery.of(context).size.width * 5 / 11;
    return ProviderWidget<HomeViewModel>(
      model: HomeViewModel(),
      onModelReady: (homeModel) {
        homeModel.initData();
        homeModel.init(height: bannerHeight - kToolbarHeight);
      },
      builder: (context, homeModel, child) {
        return Scaffold(
          body: Builder(builder: (context) {
            if (homeModel.error && homeModel.list.isEmpty) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: StatusBarUtils.systemUiOverlayStyle(context),
                  child: ViewStateErrorWidget(
                      error: homeModel.viewStateError,
                      onPressed: homeModel.initData));
            }
            return RefreshConfiguration.copyAncestor(
              context: context,
              maxOverScrollExtent: kHomeRefreshHeight,
              child: SmartRefresher(
                controller: homeModel.refreshController,
                header: HomeRefreshHeader(),
                footer: RefresherFooter(),
                enablePullDown: homeModel.list.isNotEmpty,
                onRefresh: () async {
                  await homeModel.refresh();
                  homeModel.showErrorMessage(context);
                },
                onLoading: homeModel.loadMore,
                enablePullUp: homeModel.list.isNotEmpty,
                child: CustomScrollView(
                  controller: homeModel.scrollController,
                  slivers: <Widget>[
                    SliverToBoxAdapter(),
                    SliverAppBar(
                      // 加载中并且亮色模式下,状态栏文字为黑色
                      brightness:
                          Theme.of(context).brightness == Brightness.light &&
                                  homeModel.busy
                              ? Brightness.light
                              : Brightness.dark,
                      actions: <Widget>[
                        EmptyAnimatedSwitcher(
                          display: homeModel.showTopBtn,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: BannerWidget(),
                        centerTitle: true,
                        title: GestureDetector(
                          onDoubleTap: homeModel.scrollToTop,
                          child: EmptyAnimatedSwitcher(
                            display: homeModel.showTopBtn,
                            child: Text(
                              Platform.isIOS
                                  ? 'Fun Flutter'
                                  : S.of(context).appName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      expandedHeight: bannerHeight,
                      pinned: true,
                    ),
                    if (homeModel.empty)
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child:
                            ViewStateEmptyWidget(onPressed: homeModel.initData),
                      )),
                    if (homeModel.topArticles?.isNotEmpty ?? false)
                      HomeTopArticleList(),
                    HomeArticleList(),
                  ],
                ),
              ),
            );
          }),
          floatingActionButton: ScaleAnimatedSwitcher(
              child: homeModel.showTopBtn
                  ? FloatingActionButton(
                      onPressed: homeModel.scrollToTop,
                      heroTag: 'homeEmpty',
                      key: ValueKey(Icons.vertical_align_top),
                      child: Icon(Icons.vertical_align_top),
                    )
                  : FloatingActionButton(
                      heroTag: 'homeFab',
                      key: ValueKey(Icons.search),
                      onPressed: () {},
                      child: Icon(Icons.search),
                    )),
        );
      },
    );
  }
}

class BannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Consumer<HomeViewModel>(builder: (_, homeModel, __) {
        if (homeModel.busy) {
          return CupertinoActivityIndicator();
        } else {
          var banners = homeModel?.banners ?? [];
          return Swiper(
            loop: true,
            autoplay: true,
            autoplayDelay: 5000,
            pagination: SwiperPagination(),
            itemCount: banners.length,
            itemBuilder: (ctx, index) {
              return InkWell(
                  onTap: () {
//                    var banner = banners[index];
//                    Navigator.of(context).pushNamed(RouteName.articleDetail,
//                        arguments: Article()
//                          ..id = banner.id
//                          ..title = banner.title
//                          ..link = banner.url
//                          ..collect = false);
                  },
                  child: BannerImage(banners[index].imagePath));
            },
          );
        }
      }),
    );
  }
}

class HomeTopArticleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeViewModel homeModel = Provider.of(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          Article item = homeModel.topArticles[index];
          return ArticleItemWidget(
            item,
            index: index,
            top: true,
          );
        },
        childCount: homeModel.topArticles?.length ?? 0,
      ),
    );
  }
}

class HomeArticleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeViewModel homeModel = Provider.of(context);
    if (homeModel.busy) {
      return SliverToBoxAdapter(
        child: SkeletonList(
          builder: (context, index) => ArticleSkeletonItem(),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          Article item = homeModel.list[index];
          return ArticleItemWidget(
            item,
            index: index,
          );
        },
        childCount: homeModel.list?.length ?? 0,
      ),
    );
  }
}
