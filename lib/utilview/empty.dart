import 'package:flutter/material.dart';


class EUIEmptyWidget extends StatelessWidget {
  final String message;

  EUIEmptyWidget({this.message = '暂时没有数据哦'});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Image.asset('images/eui_empty.png')
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color.fromARGB(0xff, 0xA7, 0xAC, 0xB9),
                  decoration: TextDecoration.none
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}