import 'package:flutter/foundation.dart';

class UserIdProvider with ChangeNotifier {
  String? _userId = "Iw9Rbn58aEDQ84b2MDik";

  String? get userId => _userId;

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }

  void clearUserId() {
    _userId = null;
    notifyListeners();
  }
}
