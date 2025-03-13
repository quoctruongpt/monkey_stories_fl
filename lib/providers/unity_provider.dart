import 'package:flutter/material.dart';

class UnityProvider extends ChangeNotifier {
  bool _isUnityVisible = false;

  bool get isUnityVisible => _isUnityVisible;

  void showUnity() {
    _isUnityVisible = true;
    notifyListeners();
  }

  void hideUnity() {
    _isUnityVisible = false;
    notifyListeners();
  }
}