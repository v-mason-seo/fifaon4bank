import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    _isError = false;
    _errorMessage = "";
    notifyListeners();
  }


  bool _isError = false;
  String _errorMessage = "";
  
  bool get isError => _isError;
  String get errorMessage => _errorMessage;

  void setError(bool value, String message) {
    _isError = value;
    value == true ? _errorMessage = message : _errorMessage = "";
    notifyListeners();
  }
}