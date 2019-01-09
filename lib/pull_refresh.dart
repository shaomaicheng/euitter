import 'package:flutter/material.dart';
import 'constant.dart';

class EUIPullRefreshWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _EUIPullRefreshState();
  }
}

class _EUIPullRefreshState extends State<EUIPullRefreshWidget> {

  ScrollController _scrollController;
  bool isTop = true;
  bool isBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.extentBefore == 0) {
        isTop = true;
      } else if (_scrollController.position.extentAfter == 0) {
        isBottom = true;
      } else {
        isTop = false;
        isBottom = false;
      }
    });
  }

  bool _handleGlowNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      print('is scrollstyartnotification');
    }
    if (isTop) {
      print('下拉刷新');
    }

    if (isBottom) {
      print('上拉加载');
    }

    return false;

  }


  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
          child: Column(
            children: <Widget>[
              Container(
                height: 0.0,
                color: eui_main_blue,
              ),
              Expanded(
                child: Container(
                  child: NotificationListener(
                    onNotification: _handleGlowNotification,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: 200,
                        itemBuilder: (context, index) {
                          return Container(child: Text('dog', style: TextStyle(
                              fontSize: 30.0
                          ),),);
                        },
                      ),
                  ),
                ),
              )
            ],
          ),
          onVerticalDragUpdate: (details) {
            print(details.delta);
          },
        )
    );
  }

}
