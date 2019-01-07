import 'package:flutter/material.dart';

class Toast {
  static void showToast(BuildContext context, String message) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Container(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(0x80, 0x00, 0x00, 0x00),
                  borderRadius: BorderRadius.all(
                      Radius.circular(4.0)
                  )
              ),
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
    Future.delayed(Duration(seconds: 2)).then((value) {
      overlayEntry.remove();
    });
  }
}
