import 'pull_refresh.dart';
import 'package:eui/constant.dart';
import 'package:flutter/material.dart';
import 'package:eui/refresh/pull_refresh.dart';

typedef RefreshCallback = Future<void> Function();

typedef LoadingCallback = Future<void> Function();


class EUIRefreshWidget extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;
  final LoadingCallback onLoad;

  EUIRefreshWidget({
    @required this.child,
    @required this.onRefresh,
    @required this.onLoad,
  });

  @override
  Widget build(BuildContext context) {
    return EUIRefreshIndicator(
      child: child,
      onRefresh: onRefresh,
      onLoad: onLoad,
      refreshWidget: _EUIRefreshHeader(),
      loadingWidget: _EUIRefreshHeader(),
    );
  }
}


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
      height: 70.0,
      color: Colors.white,
      child: Container(
        width: 28.0,
        height: 46.0,
        child: Image.asset('images/eui_pencil.png'),
      )
    );
  }

}