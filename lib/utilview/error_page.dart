import 'package:eui/constant.dart';
import 'package:flutter/material.dart';

typedef ReloadCallback = void Function();

class EUIErrorPageWidget extends StatelessWidget {
  final String errorMessage;
  final ReloadCallback reloadCallback;

  EUIErrorPageWidget({this.errorMessage, this.reloadCallback});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('images/eui_error_page.png'),
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Color.fromARGB(0xff, 0xA7, 0xAC, 0xB9),
                fontSize: 14.0,
                decoration: TextDecoration.none
              ),
            ),
          ),
          GestureDetector(
            onTap: reloadCallback,
            child: Container(
              width: 116.0,
              height: 32.0,
              margin: EdgeInsets.only(top: 24.0),
              child: Container(
                decoration: BoxDecoration(
                    color: eui_main_blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    )
                ),
                child: Center(
                  child: Text(
                    '重新加载',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 16.0
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
