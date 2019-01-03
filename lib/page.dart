import 'package:flutter/material.dart';
import 'button.dart';
class ButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '按钮'
        ),
      ),
      body: Builder(
        builder: (context) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: EUIButton(
                        width: 200,
                        title: '正常按钮',
                      ),
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: EUIButton(
                        enable: false,
                        width: 200,
                        title: '禁用按钮',
                      ),
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: EUIButton(
                        width: 200,
                        title: '点击按钮',
                        onClick: () {
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('点击事件')));
                        },
                      ),
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: EUIButton(
                        width: 300.0,
                        height: 100.0,
                        title: '大按钮',
                      ),
                    )
                )
              ],
            ),
          );
        },
      )
    );
  }

}