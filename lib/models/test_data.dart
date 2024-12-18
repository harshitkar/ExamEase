import '../services/random_id_generator.dart';
import 'question_data.dart';

class TestData {
  String testId;
  String testName;
  List<QuestionData> questions;
  DateTime postedAt;
  DateTime startFrom;
  DateTime deadlineTime;
  int testTime;

  TestData({
    String? testId,
    this.testName = '',
    List<QuestionData>? questions,
    DateTime? postedAt,
    DateTime? startFrom,
    DateTime? deadlineTime,
    this.testTime = 0,
  })  : testId = testId ?? RandomIdGenerator.generateTestId(),
        questions = questions ?? [],
        postedAt = postedAt ?? DateTime.now(),
        startFrom = startFrom ?? DateTime.now(),
        deadlineTime = deadlineTime ?? DateTime.now();
}