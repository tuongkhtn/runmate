import 'package:flutter/foundation.dart';

class UserIdProvider with ChangeNotifier {
  String _userId = "6NiguWUpWdgkwuhs3yQI";

  String get userId => _userId;

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }

  void clearUserId() {
    _userId = "";
    notifyListeners();
  }
}
