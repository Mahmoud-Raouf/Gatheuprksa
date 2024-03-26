import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showShortToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    fontSize: 16.0,
  );
}

void showDoneToast() {
  Fluttertoast.showToast(
    msg: "تمت العملية بنجاح",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green,
    textColor: Colors.white,
  );
}

void showInternetToast() {
  Fluttertoast.showToast(
    msg: "لا يوجد إتصال بالإنترنت",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  );
}

void showTimeoutConnectionToast() {
  Fluttertoast.showToast(
    msg: "لا يوجد إستجابة من الخادم حاول مره أخرى بعد دقائق",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  );
}

void showPoorInternetToast() {
  Fluttertoast.showToast(
    msg: "الشبكة غير مستقرة حاول مرة أخرى",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  );
}

void showActiveSuccessfullyToast() {
  Fluttertoast.showToast(
    msg: "تم التفعيل بنجاح يمكنك تسجيل الدخول الأن",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green,
    textColor: Colors.white,
  );
}

void showWrongInServerToast() {
  Fluttertoast.showToast(
    msg: "هناك خطأ بالتطبيق من فضلك راجع الدعم",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  );
}
