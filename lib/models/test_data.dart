import '../services/random_id_generator.dart';
import 'question_data.dart';

class TestData {
  String testId;
  String testName;
  List<QuestionData> questions;
  DateTime postedAt;
  DateTime startFrom;
  DateTime deadlineTime;

  TestData({
    String? testId,
    this.testName = '',
    List<QuestionData>? questions,
    DateTime? postedAt,
    DateTime? startFrom,
    DateTime? deadlineTime,
  })  : testId = testId ?? RandomIdGenerator.generateTestId(),
        questions = questions ?? [],
        postedAt = postedAt ?? DateTime.now(),
        startFrom = startFrom ?? DateTime.now(),
        deadlineTime = deadlineTime ?? DateTime.now();
}
