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

  var routerData = [
    ERouter('/button', '按钮'),
    ERouter('/dialog', '对话框'),
    ERouter('/toast', 'toast'),
    ERouter('/empty', '空视图'),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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