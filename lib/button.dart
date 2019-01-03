import 'package:flutter/material.dart';

/// EUI 按钮控件
/// EUIButton
/// 属性设置，可选属性：
/// width : 宽度
/// height : 宽度，默认 45
/// enable: 是否是可用状态
/// title: 文字
/// onClick: GestureTapCallback对象，点击事件

class EUIButton extends StatelessWidget {
  double width;
  double height = 45.0;
  bool enable = true;
  String title;
  GestureTapCallback onClick;

  EUIButton(
      {this.enable = true,
      this.width,
      this.height = 45.0,
      this.title = '',
      this.onClick}) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: this.enable ? onClick : null,
      child: Container(
        decoration: BoxDecoration(
            color: _color(),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            )),
        width: width,
        height: height,
        child: Center(
          child: Text(
            this.title,
            style: TextStyle(fontSize: 17.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  _color() {
    return enable
        ? Color.fromARGB(0xff, 0x2E, 0x86, 0xFF)
        : Color.fromARGB(0x4D, 0x2E, 0x86, 0xFF);
  }
}
