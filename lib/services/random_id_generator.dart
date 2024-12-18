import 'package:uuid/uuid.dart';

class RandomIdGenerator {
  static const Uuid _uuid = Uuid();

  static String generateQuestionId() {
    String questionId = _uuid.v4();
    // while (questionId !in Questions_table)
    //   questionId = _uuid.v4();
    return questionId;
  }

  static String generateTestId() {
    String testId = _uuid.v4();
    // while (testId !in Test_table)
    //   testId = _uuid.v4();
    return testId;
  }

  static String generateOptionId() {
    String optionId = _uuid.v4();
    // while (optionId !in Option_table)
    //   optionId = _uuid.v4();
    return optionId;
  }

  static String generateResultId() {
    String resultId = _uuid.v4();
    // while (resultId !in Result_table)
    //   resultId = _uuid.v4();
    return resultId;
  }
}
