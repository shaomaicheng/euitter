import 'package:flutter/material.dart';

/// EUI ✏️画线的widget
/// @author chenglei
class EUIPencilDrawLineWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EUIPencilDrawLineWidgetState();
  }
}

class _EUIPencilDrawLineWidgetState extends State<EUIPencilDrawLineWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
          width: 23.0,
          height: 40.0,
          child: Image.asset('images/eui_pencil.png'),
        ));
  }
}