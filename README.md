# eui

msiotng eui conponent

## 使用说明

1. # 按钮

组件名称为 `EUIButton`

类型包括：
* 正常的普通按钮
* 大按钮
* 可以点击和可以禁用的按钮

属性：
* width : 宽度
* height : 宽度，默认 45
* enable: 是否是可用状态
* title: 文字
* onClick: GestureTapCallback对象，点击事件

2. # 对话框

对话框包括：
* 简单对话框
* 只有标题的⚠️对话框
* 可以输入的对话框
* 拥有一个文本输入框的选择提示对话框

分别调用的代码为

```dart
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
    DialogClick dialogClick})
```

```dart
/// barrierDismissible 点击其他区域是否可以关闭 默认为false
/// title 标题 必须传
/// warningText 警告文案 必须传

void showEUIWarningDialog({
  @required BuildContext context,
  bool barrierDismissible = false,
  String title,
  @required String warningText,
})
```

```dart
/// title 标题
/// message 信息，可以不传
/// 正面按钮文字 positiveTitle
/// 正面按钮点击事件 positiveClick
/// 反面按钮文字 negativeTitle
/// 反面按钮点击事件 negativeClick
/// 是否有一个输入框 hasInputBox
/// 输入框的隐藏文字 hintText
/// 输入框内容变化的监听回调 valueChanged

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
    ValueChanged<String> valueChanged})
```

```dart
/// title 标题
/// message 信息，可以不传
/// positiveTitle 正面按钮文字
/// positiveClick 正面按钮点击事件
/// negativeTitle 反面按钮文字
/// negativeClick 反面按钮点击事件
/// hintText 否有一个输入框
/// hintText 输入框的隐藏文字
/// valueChanged 输入框内容变化的监听回调

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
    ValueChanged<String> valueChanged})
```

3. # 空视图

EUIEmptyWidget

参数： message 提示文案

4. # 错误提示

EUIErrorPageWidget
参数：
* errorMessage 错误文案
* reloadCallback 重新加载的回调

5. # TOAST

Toast.showToast(context, message)

message: toast 的提示文案

6. # ✏️ 画画的加载效果

EUIPencilDrawLineWidget

7. # 下拉刷新

组件名称： EUIRefreshWidget

必须传递的属性：
* child Widget 例如listview
* onRefresh RefreshCallback 下拉刷新的回调
* onLoad LoadingCallback 上拉加载的回调
* hasMore 是否有更多的数据可以加载

使用方式：

如果没有数据的时候，需要手动刷新 state 里面的hasMore 来控制是否可以上拉加载
同理，如果下拉刷新在 hasMore 为false的时候调用，需要重新置为 true

8. # 列表项目

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