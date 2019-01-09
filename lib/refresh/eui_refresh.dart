import 'pull_refresh.dart';
import 'package:eui/constant.dart';
import 'package:flutter/material.dart';

class EUIRefreshWidget extends StatelessWidget {
  final Widget child;

  EUIRefreshWidget({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return EUIRefreshIndicator(
      child: child,
      onRefresh: () {},
      onLoad: () {},
      refreshWidget: Container(
        color: eui_main_blue,
        child: Text('mistong eui'),
      ),
    );
  }
}
