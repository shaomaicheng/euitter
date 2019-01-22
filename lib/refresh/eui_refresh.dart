import 'package:flutter/material.dart';

import 'smart_refresher.dart';
import 'package:eui/refresh/smart_refresher.dart';
import 'package:eui/eui_pencil.dart';

typedef RefreshCallback = Future<void> Function();

typedef LoadingCallback = Future<void> Function();

class EUIRefreshWidget extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;
  final LoadingCallback onLoad;
  final RefreshController refreshController = RefreshController();
  final bool hasMore;
  EUIRefreshWidget({
    @required this.child,
    @required this.onRefresh,
    @required this.onLoad,
    @required this.hasMore,
  });

  bool refreshing = false;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      child: child,
      onRefresh: (up) {
        if (refreshing) {}
        refreshing = true;
        if (up) {
          // 上拉刷新
          onRefresh().whenComplete(() {
            refreshController.sendBack(true, RefreshStatus.completed);
            refreshing = false;
          });
        } else {
          // 下拉加载
          onLoad().whenComplete(() {
            refreshController.sendBack(false, RefreshStatus.idle);
            refreshing = false;
          });
        }
      },
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: hasMore? true : false,
      footerBuilder: (context, mode) {
        return Container(
          child: _EUIRefreshFooter(),
        );
      },
      headerBuilder: (context, mode) {
        return Container(
          child: _EUIRefreshHeader(),
        );
      },
    );
  }
}

/**
 * header
 */
class _EUIRefreshHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EUIRefreshHeaderState();
  }
}

class _EUIRefreshHeaderState extends State<_EUIRefreshHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
          width: 23.0,
          height: 40.0,
          child: Image.asset('images/eui_pencil.png'),
        ));
  }
}

/**
 * footer
 */
class _EUIRefreshFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EUIPencilDrawLineWidget();
  }

}
