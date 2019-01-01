import 'package:flutter/material.dart';

void main() => runApp(EUIAPP());

class EUIAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EUI',
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

class EUIWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

    );
  }

}