import 'package:eui/constant.dart';
import 'package:flutter/material.dart';
import 'dart:io';

typedef DialogClick = void Function();

const euiDialogBg = Color.fromARGB(0xf2, 0xff, 0xff, 0xff);

/// 简单对话框
/// barrierDismissible 点击其他区域是否会消失
/// title 标题
/// message 信息
/// btnTitle 单按钮的文案
/// dialogClick 点击按钮的行为
void showEUISimpleDialog(
    {@required BuildContext context,
    bool barrierDismissible = true,
    String title,
    String message = '',
    @required String btnTitle,
    DialogClick dialogClick}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Platform.isAndroid
            ? _androidSimpleDialogWidget(
                context: context,
                title: title,
                message: message,
                btnTitle: btnTitle,
                dialogClick: dialogClick)
            : _iOSSimpleDialogWidget(
                context: context,
                title: title,
                message: message,
                btnTitle: btnTitle,
                dialogClick: dialogClick);
      });
}

Widget _androidSimpleDialogWidget(
    {@required BuildContext context,
    String title = '',
    String message = '',
    @required String btnTitle,
    DialogClick dialogClick}) {
  return Center(
    child: Container(
      width: 271.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          EUIAndroidDialogHeader(
            title: title,
            message: message,
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0, right: 20.0, bottom: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                btnTitle,
                style: TextStyle(
                    fontSize: 16.0,
                    color: eui_main_blue,
                    decoration: TextDecoration.none),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _iOSSimpleDialogWidget(
    {@required BuildContext context,
    String title,
    String message = '',
    @required String btnTitle,
    DialogClick dialogClick}) {
  return Center(
    child: Container(
      width: 271.0,
      decoration: BoxDecoration(
        color: euiDialogBg,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          EUIIOSDialogHeader(title: title, message: message),
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
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

/// 只有标题的警告框
/// barrierDismissible 点击其他区域是否可以关闭 默认为false
/// title 标题 必须传
/// warningText 警告文案 必须传
void showEUIWarningDialog({
  @required BuildContext context,
  bool barrierDismissible = false,
  String title,
  @required String warningText,
}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Platform.isAndroid
            ? _androidWarningWidget(
                context: context,
                title: title,
                warningText: warningText,
              )
            : _iosWarningWidget(
                context: context,
                title: title,
                warningText: warningText,
              );
      });
}

Widget _androidWarningWidget({
  @required BuildContext context,
  String title,
  @required String warningText,
}) {
  return Center(
    child: Container(
      width: 271.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          EUIAndroidDialogHeader(
            title: title,
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0, right: 20.0, bottom: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '取消',
                      style: TextStyle(
                          color: eui_main_blue,
                          fontSize: 16.0,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        warningText,
                        style: TextStyle(
                            color: Color.fromARGB(0xff, 0xFA, 0x4A, 0x23),
                            fontSize: 16.0,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _iosWarningWidget({
  @required BuildContext context,
  String title,
  @required String warningText,
}) {
  return Center(
    child: Container(
      width: 271.0,
      decoration: BoxDecoration(
        color: euiDialogBg,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          EUIIOSDialogHeader(title: title),
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
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

/// alert 对话框
/// title 标题
/// message 信息，可以不传
/// 正面按钮文字
/// 正面按钮点击事件
/// 反面按钮文字
/// 反面按钮点击事件
/// 是否有一个输入框
/// 输入框的隐藏文字
/// 输入框内容变化的监听回调
void showEUIAlertDialog(
    {@required BuildContext context,
    bool barrierDismissible = true,
    String title,
    String message = '',
    @required String positiveTitle,
    @required DialogClick positiveClick,
    @required String negativeTitle,
    @required DialogClick negativeClick,
    bool hasInputBox = false,
    String hintText = '请输入文字',
    ValueChanged<String> valueChanged}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Platform.isAndroid
            ? _androidAlertDialogWidget(
                context: context,
                title: title,
                message: message,
                positiveClick: positiveClick,
                positiveTitle: positiveTitle,
                negativeTitle: negativeTitle,
                negativeClick: negativeClick,
                hasInputBox: hasInputBox,
                hintText: hintText,
                valueChanged: valueChanged)
            : _iosAlertDialogWidget(
                context: context,
                title: title,
                message: message,
                positiveClick: positiveClick,
                positiveTitle: positiveTitle,
                negativeTitle: negativeTitle,
                negativeClick: negativeClick,
                hasInputBox: hasInputBox,
                hintText: hintText,
                valueChanged: valueChanged);
      });
}

Widget _androidAlertDialogWidget(
    {@required BuildContext context,
    String title = '',
    String message = '',
    @required String positiveTitle,
    @required DialogClick positiveClick,
    @required String negativeTitle,
    @required DialogClick negativeClick,
    bool hasInputBox = false,
    String hintText = '请输入文字',
    ValueChanged<String> valueChanged}) {
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
          EUIAndroidDialogHeader(
            title: title,
            message: message,
            hintText: hintText,
            valueChanged: valueChanged,
            hasInputBox: hasInputBox,
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0, right: 20.0, bottom: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: negativeClick,
                    child: Text(
                      negativeTitle,
                      style: TextStyle(
                          color: eui_main_blue,
                          fontSize: 16.0,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40.0),
                    child: GestureDetector(
                      onTap: positiveClick,
                      child: Text(
                        positiveTitle,
                        style: TextStyle(
                            color: eui_main_blue,
                            fontSize: 16.0,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _iosAlertDialogWidget(
    {@required BuildContext context,
    String title = '',
    String message = '',
    @required String positiveTitle,
    @required DialogClick positiveClick,
    @required String negativeTitle,
    @required DialogClick negativeClick,
    bool hasInputBox = false,
    String hintText = '请输入文字',
    ValueChanged<String> valueChanged}) {
  return Center(
    child: Container(
      width: 271.0,
      decoration: BoxDecoration(
        color: euiDialogBg,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          EUIIOSDialogHeader(
            title: title,
            message: message,
            hasInputBox: hasInputBox,
            valueChanged: valueChanged,
          ),
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
                              decoration: TextDecoration.none),
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
                            decoration: TextDecoration.none),
                      ),
                    )),
                    flex: 1,
                  ),
                ],
              ))
        ],
      ),
    ),
  );
}

///  拥有一个文本输入框的选择提示对话框
/// alert 对话框
/// title 标题
/// message 信息，可以不传
/// 正面按钮文字
/// 正面按钮点击事件
/// 反面按钮文字
/// 反面按钮点击事件
/// 是否有一个输入框
/// 输入框的隐藏文字
/// 输入框内容变化的监听回调
showEUIInputAlertDialog(
    {@required BuildContext context,
    bool barrierDismissible = true,
    String title,
    String message = '',
    @required String positiveTitle,
    @required DialogClick positiveClick,
    @required String negativeTitle,
    @required DialogClick negativeClick,
    String hintText,
    ValueChanged<String> valueChanged}) {
  showEUIAlertDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      title: title,
      positiveTitle: positiveTitle,
      positiveClick: positiveClick,
      negativeTitle: negativeTitle,
      negativeClick: negativeClick,
      message: message,
      hasInputBox: true,
      hintText: hintText,
      valueChanged: valueChanged);
}

class EUIAndroidDialogHeader extends StatelessWidget {
  final String message;
  final String title;
  final bool hasInputBox;
  final String hintText;
  final ValueChanged<String> valueChanged;

  EUIAndroidDialogHeader(
      {this.title = '',
      this.message = '',
      this.hasInputBox = false,
      this.hintText = '请输入文字',
      this.valueChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0, left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Offstage(
              offstage: title.isEmpty,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0),
          child: Offstage(
            offstage: message.isEmpty,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 14.0,
                    decoration: TextDecoration.none,
                    color: Color.fromARGB(0xff, 0x2A, 0x33, 0x3A)),
              ),
            ),
          ),
        ),
        Offstage(
          offstage: !hasInputBox,
          child: Container(
            margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Card(
              child: TextField(
                onChanged: valueChanged,
                decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: 13.0,
                      color: Color.fromARGB(0xff, 0xC8, 0xCB, 0xD4),
                    )),
                style: TextStyle(
                    color: Color.fromARGB(0xff, 0x2A, 0x33, 0x3A),
                    fontSize: 13.0),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class EUIIOSDialogHeader extends StatelessWidget {
  final String message;
  final String title;
  final bool hasInputBox;
  final String hintText;
  final ValueChanged<String> valueChanged;

  EUIIOSDialogHeader(
      {this.title = '',
      this.message = '',
      this.hasInputBox = false,
      this.hintText = '请输入文字',
      this.valueChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Offstage(
            offstage: title.isEmpty,
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
        Offstage(
          offstage: !hasInputBox,
          child: Container(
            margin: EdgeInsets.only(top: 15.0, left: 17.0, right: 15.0),
            child: Form(
                child: Card(
                    child: Container(
              child: TextField(
                onChanged: valueChanged,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 8.0, bottom: 8.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                        borderSide: BorderSide(
                            color: Color.fromARGB(0xff, 0xE6, 0xE7, 0xEB),
                            width: 1.0)),
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: 13.0,
                      color: Color.fromARGB(0xff, 0xC8, 0xCB, 0xD4),
                    )),
                style: TextStyle(
                    color: Color.fromARGB(0xff, 0x2A, 0x33, 0x3A),
                    fontSize: 13.0),
              ),
            ))),
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
