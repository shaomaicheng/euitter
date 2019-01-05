import 'package:flutter/material.dart';

typedef DialogClick = void Function();

/// 简单对话框
/// barrierDismissible 点击其他区域是否会消失
/// title 标题
/// message 信息
/// btnTitle 单按钮的文案
/// dialogClick 点击按钮的行为
void ShowEUISimpleDialog({
  @required BuildContext context,
  bool barrierDismissible = true,
  @required String title,
  String message = '',
  @required String btnTitle,
  DialogClick dialogClick
}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Center(
          child: Container(
            width: 271.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                EUIDialogHeader(title, message: message),
                Container(
                  height: 44.0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (dialogClick == null) {
                          Navigator.of(context).pop();
                          return;
                        }
                        dialogClick();
                      },
                      child: Text(
                        btnTitle,
                        style: TextStyle(
                            color: Color.fromARGB(0xff, 0x2E, 0x86, 0xFF),
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}

/// 只有标题的警告框
/// barrierDismissible 点击其他区域是否可以关闭 默认为false
/// title 标题 必须传
/// warningText 警告文案 必须传
void showEUIWarningDialog({
  @required BuildContext context,
  bool barrierDismissible = false,
  @required String title,
  @required String warningText,
}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Center(
          child: Container(
            width: 271.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                EUIDialogHeader(title),
                Container(
                  height: 44.0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        warningText,
                        style: TextStyle(
                            color: Color.fromARGB(0xff, 0xFA, 0x4A, 0x23),
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}

/// alert 对话框
/// title 标题
/// message 信息，可以不传
/// 正面按钮文字
/// 正面按钮点击事件
/// 反面按钮文字
/// 反面按钮点击事件
void ShowEUIAlertDialog({
  @required BuildContext context,
  bool barrierDismissible = true,
  @required String title,
  String message = '',
  @required String positiveTitle,
  @required DialogClick positiveClick,
  @required String negativeTitle,
  @required DialogClick negativeClick
}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Center(
          child: Container(
            width: 271.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                EUIDialogHeader(title),
                Container(
                  height: 44.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: positiveClick,
                            child: Text(
                              positiveTitle,
                              style: TextStyle(
                                  color: Color.fromARGB(0xff, 0x2E, 0x86, 0xFF),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.none
                              ),
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Container(
                        width: 1.0,
                        height: 44.0,
                        color: Color.fromARGB(0xff, 0xE6, 0xE7, 0xEB),
                      ),
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: negativeClick,
                            child: Text(
                              negativeTitle,
                              style: TextStyle(
                                  color: Color.fromARGB(0xff, 0x2E, 0x86, 0xFF),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.none
                              ),
                            ),
                          )
                        ),
                        flex: 1,
                      ),
                    ],
                  )
                )
              ],
            ),
          ),
        );
      });
}

class EUIDialogHeader extends StatelessWidget {

  String message;
  String title;

  EUIDialogHeader(this.title, {this.message = ''}) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
        Offstage(
          offstage: message.isEmpty,
          child: Container(
            margin: EdgeInsets.only(top: 1.0, left: 14.0, right: 13.0),
            child: Center(
              child: Text(
                message,
                style: TextStyle(
                    color: Color.fromARGB(0xff, 0x2A, 0x33, 0x3A),
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          height: 1.0,
          color: Color.fromARGB(0xff, 0xE6, 0xE7, 0xEB),
        ),
      ],
    );
  }

}
