# eui

msiotng eui conponent

## 使用说明

1. 列表项目

通用列表项，一般用在个人中心页面之类的，大概包括如下三种
* 导航， 右边是文字、小箭头，两者都在或者都不在的ui组件
* 开关，右边是开关
* 右边是自定义的组件

通过 `EUIListItem` 我们可以配置类型和参数，支持以上几种业务场景

```dart
import 'package:eui/item/item_list.dart';
```

支持的类型, `Type`
* ARROW
* SWITCH
* CUSTOM

示例：

纯arrow的, 左边有图片，中间是标题，右边是导航文字和图标的

```dart
EUIListItem(
                  true,
                  title: '测试的单行的标题',
                  imgUri: 'images/eui_pencil.png',
                  onArrowClick: () {
                    Toast.showToast(context, '点击!');
                  },
                  arrowText: '跳转引导文字',
                ),
```

纯 arrow 的， 双行文字包括副标题，左侧图片偏大，右侧导航内容同上

```dart
EUIListItem(
                  false,
                  title: '测试的多行的标题',
                  imgUri: 'images/eui_pencil.png',
                  subTitle: '测试的多行的副标题',
                  arrowText: '跳转引导文字',
                  showArrow: true,
                  onArrowClick: () {
                    Toast.showToast(context, '点击!');
                  },
                ),
```

右侧是 switch 开关的
```dart
EUIListItem(
                  true,
                  title: '带开关的',
                  subTitle: '设置了也不会生效的',
                  itemType: Type.SWITCH,
                  switchValue: false,
                  onSwitchChange: (value) {
                    print('switch是否open: $value');
                  },
                ),
```

右侧使用自定义的 widget

```dart
EUIListItem(
                  true,
                  title: '右侧是自定义widget',
                  itemType: Type.CUSTOM,
                  right: Container(
                    width: 50.0,
                    height: 50.0,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.asset('images/eui_pencil.png'),
                  )
                ),
```

具体使用见示例的 `page.dart`

参数说明如下：
* signLine 必选。是否单行，是的话 true 双行为 false
* itemType 选择的类型，类型说明如上。默认为 arrow
* imgUri 左侧图片的 asset uri 或者 url
* title 标题
* subTitle 副标题， signLine 为 false 的时候设置无效
* showArrow 导航图标是否显示，仅 type 为 arrow 的时候有效
* arrowText 导航图标左侧的文字，仅 type 为 arrow 的时候有效
* onArrowClick 导航点击的事件回调， 仅 type 为 arrow 的时候有效
* switchValue switch 开关切换回调，仅 type 为 switch 的时候有效
* switchValue switch 开关的默认值，仅 type 为 switch 的时候有效
* right 右侧自定义的 widget 内容，仅 type 为 custom 的时候有效