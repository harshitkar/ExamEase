import 'package:ocr_app/models/classroom_data.dart';
import 'package:ocr_app/models/test_data.dart';
import 'package:ocr_app/models/user_data.dart';

class DataHolder {
  static ClassroomData? currentClassroom;
  static UserData? currentUser;
  static TestData? currentTest;

  /// Clear all stored data (useful for logout or reset scenarios)
  static void clear() {
    currentClassroom = null;
    currentUser = null;
    currentTest = null;
  }
}
