import 'package:eui/dialog.dart';
import 'package:flutter/material.dart';
import 'button.dart';
import 'toast.dart';
import 'empty.dart';
import 'error_page.dart';

class ButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('按钮'),
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
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: EUIButton(
                          enable: false,
                          width: 200,
                          title: '禁用按钮',
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: EUIButton(
                          width: 200,
                          title: '点击按钮',
                          onClick: () {
                            Scaffold.of(context)
                                .showSnackBar(SnackBar(content: Text('点击事件')));
                          },
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: EUIButton(
                          width: 300.0,
                          height: 100.0,
                          title: '大按钮',
                        ),
                      ))
                ],
              ),
            );
          },
        ));
  }
}

class DialogWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DialogState();
  }
}

class _DialogState extends State<DialogWidget> {
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('对话框'),
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
                        width: 100.0,
                        title: '简单对话框',
                        onClick: () {
                          showEUISimpleDialog(
                              context: context,
                              title: '标题',
                              message: '简单对话框',
                              btnTitle: '确定',
                              dialogClick: () {
                                Navigator.of(context).pop();
                              });
                        },
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: EUIButton(
                        width: 200.0,
                        title: '提示选择对话框',
                        onClick: () {
                          showEUIAlertDialog(
                              context: context,
                              message: '简单选择对话框',
                              title: '标题',
                              positiveTitle: '是',
                              positiveClick: () {
                                Navigator.of(context).pop();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('您点击了"是"'),
                                ));
                              },
                              negativeTitle: '否',
                              negativeClick: () {
                                Navigator.of(context).pop();
                              });
                        },
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: EUIButton(
                        width: 200.0,
                        title: '只有标题的简单对话框',
                        onClick: () {
                          showEUIAlertDialog(
                              context: context,
                              title: '标题',
                              positiveTitle: '是',
                              positiveClick: () {
                                Navigator.of(context).pop();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('您点击了"是"'),
                                ));
                              },
                              negativeTitle: '否',
                              negativeClick: () {
                                Navigator.of(context).pop();
                              });
                        },
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: EUIButton(
                        width: 200.0,
                        title: '只有文字的警告对话框',
                        onClick: () {
                          showEUIWarningDialog(
                              context: context,
                              title: '标题',
                              warningText: '警告文字');
                        },
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: EUIButton(
                        width: 200.0,
                        title: '带输入框的提示对话框',
                        onClick: () {
                          showEUIInputAlertDialog(
                              context: context,
                              title: '标题',
                              message: 'message',
                              positiveTitle: '是',
                              positiveClick: () {
                                Navigator.of(context).pop();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('输入的值：$_inputText'),
                                ));
                              },
                              negativeClick: () {},
                              negativeTitle: '否',
                              hintText: '提示输入文字',
                              valueChanged: (value) {
                                _inputText = value;
                              });
                        },
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ToastWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('toast'),
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
                        width: 200.0,
                        title: '弹一条普通的toast',
                        onClick: () {
                          Toast.showToast(context, '这是一条普通的toast');
                        },
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: EUIButton(
                        width: 200.0,
                        title: '弹一条文字长的toast',
                        onClick: () {
                          Toast.showToast(context,
                              '这是一条普通的toast啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊');
                        },
                      ),
                    ))
              ],
            ),
          );
        },
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('空视图'),
      ),
      body: Builder(
        builder: (context) {
          return Container(
            child: EUIEmptyWidget(
              message: '暂时没有观看记录',
            ),
          );
        },
      ),
    );
  }
}

class ErrorAndReloadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('出错提示页'),
      ),
      body: Builder(
        builder: (context) {
          return Container(
            child: EUIErrorPageWidget(
              errorMessage: '不同情况出错提示文字',
              reloadCallback: () {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('重新加载')));
              },
            ),
          );
        },
      ),
    );
  }
}
