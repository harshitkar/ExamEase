import 'package:uuid/uuid.dart';

class RandomIdGenerator {
  static const Uuid _uuid = Uuid();

  // Generates a random UUID as a string
  static String generateId() {
    return _uuid.v4(); // v4 generates a random UUID
  }
}
