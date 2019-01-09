import 'package:flutter/material.dart';

class Toast {
  static void showToast(BuildContext context, String message) {
    _ToastView toastView = _ToastView();
    if (toastView.showing) {
      toastView.dismiss();
    }
    toastView.show(context, message);
  }
}

class _ToastView {
  bool showing = false;

  _ToastView._construct();

  factory _ToastView() => _getInstance();

  static _ToastView _instance;

  static _getInstance() {
    if (_instance == null) {
      _instance = _ToastView._construct();
    }
    return _instance;
  }

  OverlayState overlayState;
  OverlayEntry overlayEntry;

  _Toast _toast;

  show(BuildContext context, String message) {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      _toast = _Toast(message, () {
        // overlayEntry?.remove();
      });
      return _toast;
    });
    overlayState.insert(overlayEntry);
    showing = true;
    Future.delayed(Duration(seconds: 2)).then((value) {
      dismiss();
    });
    Future.delayed(Duration(milliseconds: 2500))
    .then((value) {
      overlayEntry?.remove();
    });
  }

  dismiss() {
    if (showing) {
      _toast?.dismiss();
    }
    showing = false;
  }

  isShowing() {
    return showing;
  }
}

typedef AnimationListener = void Function();

class _Toast extends StatefulWidget {
  final String message;
  final _ToastState _state = _ToastState();
  final AnimationListener reverseListener;

  _Toast(this.message, this.reverseListener);

  @override
  State<StatefulWidget> createState() {
    return _state;
  }

  dismiss() {
    _state?.dismiss();
  }
}

class _ToastState extends State<_Toast> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  int completeCount;

  @override
  void initState() {
    super.initState();
    completeCount = 1;
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
        }
      });
    controller?.forward();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  dismiss() {
    controller?.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(0x80, 0x00, 0x00, 0x00),
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 201.0, minWidth: 132.0),
                    margin: EdgeInsets.all(16.0),
                    child: Align(
                      child: Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}
