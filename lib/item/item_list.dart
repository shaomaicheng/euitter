import 'package:eui/constant.dart';
import 'package:flutter/material.dart';

///
/// 类似个人中心页面的 item ui 单行列表 样式
/// 最左侧可以设置是否显示图标
/// 最右侧设置显示的内容：导航、导航文字、switch、选中、自定义内容
///
///


class EUIListItem extends StatelessWidget {

  final bool signLine;
  final String title;
  final String imgUri; // can assets or network
  final String subTitle;
  final Type itemType; // custom arrow or switch

  /// arrow
  final String arrowText; ///arrow text
  final bool showArrow;

  EUIListItem(
    this.signLine
      ,{
    this.imgUri = '',
    this.title = '',
        this.subTitle = '',
        this.itemType = Type.ARROW,
        this.arrowText = '',
        this.showArrow = true,
  }) {
    switch (itemType) {
      case Type.ARROW:
       assert(this.arrowText != null || this.showArrow != null);
        break;
      case Type.SWITCH:
        break;
      case Type.CUSTOM:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
        height: 60.0,
        child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: this.signLine?20.0:12.0, horizontal: 16.0),
                  child: _Icon(
                      imgUri,
                      iconSize: this.signLine? IconSize.NORMAL:IconSize.LARGE),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: this.signLine?20.0 : 9.0
                    ),
                      child: _whichTitle()
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        arrowText,
                        style: arrowTextStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4.0, right: 12.0, top: 12.0, bottom: 12.0),
                      width: 10.0,
                      height: 10.0,
                      child: Image.asset('images/eui_arrow.png'),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 1.0,
            color: eui_listitem_splitline_color,
            margin: EdgeInsets.symmetric(horizontal: 12.0),
          )
        ],
      )
    );
  }

  Widget _whichTitle() {
    return this.signLine?
    Text(
      title,
      style: titleStyle,
    ) :
        Align(
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: titleStyle,
              ),
              Text(
                subTitle,
                style: subTitleStyle,
              )
            ],
          ),
          alignment: Alignment.centerLeft,
        );
  }

}

enum Type {
  ARROW,
  SWITCH,
  CUSTOM
}

final TextStyle titleStyle = TextStyle(
  color: Color.fromARGB(0xff, 0x2A, 0x33, 0x3A),
  fontSize: 15.0
);

final TextStyle subTitleStyle = TextStyle(
  color: Color.fromARGB(0xff, 0x6B, 0x78, 0x84),
  fontSize: 12.0
);
final TextStyle arrowTextStyle = TextStyle(
  color: Color.fromARGB(0xff, 0x6B, 0x78, 0x84),
  fontSize: 15.0
);

/// list item 里面的左侧图标
/// 自动判断是 assets 内的资源图片 还是 网络图片
class _Icon extends StatelessWidget {

  final String uri;
  final IconSize iconSize;

  _Icon(this.uri, {this.iconSize = IconSize.NORMAL});

  @override
  Widget build(BuildContext context) {
    var fromNetwork = _fromNetwork(uri);
    return Container(
      width: _iconSize(),
      height: _iconSize(),
      child: fromNetwork ? NetworkImage(uri) : Image.asset(uri)
    );
  }

  bool _fromNetwork(String uri) {
    Uri realUri = Uri.parse(uri);
    var scheme = realUri.scheme;
    return scheme == 'http' || scheme == 'https';
  }

  _iconSize() {
    return iconSize == IconSize.NORMAL ? 20.0 : 36.0;
  }

}

enum IconSize {
  LARGE,
  NORMAL,
}