// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AppLoaderProvider with ChangeNotifier {
  bool _showLoader = false;

  bool get showLoader => _showLoader;

  void show() {
    _setLoaderState(true);
  }

  void hide() {
    _setLoaderState(false);
  }

  void _setLoaderState(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoader = value;
      notifyListeners();
    });
  }
}
