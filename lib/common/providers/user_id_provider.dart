import 'package:flutter/foundation.dart';

class UserIdProvider with ChangeNotifier {
  String? _userId = "ziGLEpsEcwazHVWee44w";

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
