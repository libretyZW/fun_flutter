import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_flutter/config/resource_mananger.dart';
import 'package:fun_flutter/ui/page/home_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fun_flutter/ui/widget/activity_indicator.dart';

/// 首页列表的header
class HomeRefreshHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var strings = RefreshLocalizations.of(context)?.currentLocalization ??
        EnRefreshString();
    return ClassicHeader(
      outerBuilder: (child) => HomeSecondFloorOuter(child),
      twoLevelView: Container(),
      height: 70 + MediaQuery.of(context).padding.top / 3,
      refreshingIcon: ActivityIndicator(brightness: Brightness.dark),
      releaseText: strings.canRefreshText,
    );
  }
}

class HomeSecondFloorOuter extends StatelessWidget {
  final Widget child;

  HomeSecondFloorOuter(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHomeRefreshHeight + MediaQuery.of(context).padding.top + 20,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              ImageHelper.wrapAssets('home_second_floor_builder.png')),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text('跌跌撞撞中,依旧热爱这个世界.',
                style: Theme.of(context).textTheme.overline.copyWith(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Align(alignment: Alignment(0, 0.85), child: child),
        ],
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}

/// 通用的footer
///
/// 由于国际化需要context的原因,所以无法在[RefreshConfiguration]配置
class RefresherFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
//      failedText: S.of(context).loadMoreFailed,
//      idleText: S.of(context).loadMoreIdle,
//      loadingText: S.of(context).loadMoreLoading,
//      noDataText: S.of(context).loadMoreNoData,
    );
  }
}

