import 'package:flutter/material.dart';

import 'smart_refresher.dart';
import 'package:eui/refresh/smart_refresher.dart';
import 'package:eui/utilview/eui_pencil.dart';

typedef RefreshCallback = Future<void> Function();

typedef LoadingCallback = Future<void> Function();

class EUIRefreshWidget extends StatefulWidget {
  final Widget child;
  final RefreshCallback onRefresh;
  final LoadingCallback onLoad;
  final RefreshController refreshController = RefreshController();
  final bool hasMore;
  final Widget refrshWidget;
  final Widget loadMoreWidget;

  EUIRefreshWidget({
    @required this.child,
    @required this.onRefresh,
    @required this.onLoad,
    @required this.hasMore,
    this.refrshWidget,
    this.loadMoreWidget
  });

  @override
  State<StatefulWidget> createState() {
    return _EUIRefreshState();
  }
}

class _EUIRefreshState extends State<EUIRefreshWidget> {
  bool refreshing = false;
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      child: widget.child,
      onRefresh: (up) {
        if (refreshing) {}
        refreshing = true;
        if (up) {
          // 上拉刷新
          widget.onRefresh().whenComplete(() {
            widget.refreshController.sendBack(true, RefreshStatus.completed);
            refreshing = false;
          });
        } else {
          // 下拉加载
          widget.onLoad().whenComplete(() {
            widget.refreshController.sendBack(false, RefreshStatus.idle);
            refreshing = false;
          });
        }
      },
      controller: widget.refreshController,
      enablePullDown: true,
      enablePullUp: widget.hasMore? true : false,
      footerBuilder: (context, mode) {
        return Container(
//          child: _EUIRefreshFooter(),
        child: widget.loadMoreWidget == null ? _EUIRefreshFooter() : widget.loadMoreWidget,
        );
      },
      headerBuilder: (context, mode) {
        return Container(
//          child: _EUIRefreshHeader(),
          child: widget.refrshWidget == null ? _EUIRefreshFooter() : widget.refrshWidget,
        );
      },
    );
  }

}

/// header
class _EUIRefreshHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EUIPencilDrawLineWidget();
  }
}

/// footer
class _EUIRefreshFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EUIPencilDrawLineWidget();
  }

}
