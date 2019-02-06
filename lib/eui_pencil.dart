import 'package:flutter/material.dart';

/// EUI ✏️ 画线的widget
/// @author chenglei
class EUIPencilDrawLineWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EUIPencilDrawLineWidgetState();
}

class _EUIPencilDrawLineWidgetState extends State<EUIPencilDrawLineWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animation = CurvedAnimation(parent: animationController, curve: Interval(0.1, 1))
    ..addStatusListener((AnimationStatus status) {
      switch (status) {
        case AnimationStatus.completed:
          animationController.reverse();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.dismissed:
          animationController.forward();
          break;
        case AnimationStatus.reverse:
          break;
        default:
          break;
      }
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return _PencilWidget(
            animation: animation,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class _PencilWidget extends StatelessWidget {
  final Animation<double> animation;
  final marginLeftAnimation = Tween<double>(begin: 0.0, end: 20.0);
  final marginRightAnimation = Tween<double>(begin:20.0, end: 0.0);
  final lineWidthAnimation = Tween<double>(begin: 0.0,end: 11.5);


  _PencilWidget({this.animation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: marginLeftAnimation.evaluate(animation), right: marginRightAnimation.evaluate(animation)),
                width: 23.0,
                height: 40.0,
                child: Image.asset('images/eui_pencil.png'),
              ),
              Container(
                margin: EdgeInsets.only(top: 2.0, right: 23.0, left: 11.5),
                color: Colors.grey,
                height: 0.5,
                width: lineWidthAnimation.evaluate(animation),
              )
            ],
          );
        },
      ),
    );
  }
}
