import 'package:flutter/foundation.dart';

class UserIdProvider with ChangeNotifier {
  String? _userId = "1f7JM0h0P7U4FRCF1v7L";

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
