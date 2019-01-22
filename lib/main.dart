import 'package:flutter/material.dart';
import 'page.dart';

void main() => runApp(EUIAPP());

class EUIAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EUI',
      routes: {
        '/button': (context) => ButtonWidget(),
        '/dialog': (context) => DialogWidget(),
        '/toast': (context) => ToastWidget(),
        '/empty': (context) => EmptyWidget(),
        '/error': (context) => ErrorAndReloadWidget(),
        '/pullrefresh': (context) => PullRefreshWidget(),
        '/pencilDrawLine': (context) => PencilLoadingPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EUIHomePage(),
    );
  }
}

class EUIHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EUI'
        ),
      ),
      body: EUIWidget(),
    );
  }

}

class ERouter {
  String routerName;
  String showTitle;

  ERouter(this.routerName, this.showTitle);

}
class EUIWidget extends StatelessWidget {

  final List<ERouter> routerData = [
    ERouter('/button', '按钮'),
    ERouter('/dialog', '对话框'),
    ERouter('/toast', 'toast'),
    ERouter('/empty', '空视图'),
    ERouter('/error', '错误提示'),
    ERouter('/pullrefresh', '下拉刷新'),
    ERouter('/pencilDrawLine', '铅笔画线')
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: routerData.length,
        itemBuilder: (BuildContext context, int index) {
          ERouter eRouter = routerData[index];
          return Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Center(
                child: RaisedButton(
                  child: Text(
                    eRouter.showTitle,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black
                    ),
                  ),
                  onPressed:() {
                    Navigator.of(context)
                        .pushNamed(eRouter.routerName);
                  },
                )
            ),
          );
        },
      ),
    );
  }

}