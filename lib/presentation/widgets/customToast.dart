import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasts {
  static getErrorToast({@required String? text}) async {
    await Fluttertoast.showToast(
        msg: text ?? "Please try again Toasts",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static getSuccessToast({@required String? text}) async {
    await Fluttertoast.showToast(
        msg: text ?? "Please try again Toasts",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static getWarningToast({@required String? text}) async {
    await Fluttertoast.showToast(
        msg: text ?? "Please try again Toasts.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
