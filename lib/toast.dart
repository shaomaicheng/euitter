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

  show(BuildContext context, String message) {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Container(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(0x80, 0x00, 0x00, 0x00),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: Container(
                constraints: BoxConstraints(maxWidth: 201.0, minWidth: 132.0),
                margin: EdgeInsets.all(16.0),
                child: Align(
                  child: Text(
                    message,
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
      ));
    });
    overlayState.insert(overlayEntry);
    showing = true;
    Future.delayed(Duration(seconds: 2)).then((value) {
      dismiss();
    });
  }

  dismiss() {
    if (showing) {
      overlayEntry?.remove();
    }
    showing = false;
  }

  isShowing() {
    return showing;
  }
}
