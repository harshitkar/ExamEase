import 'package:ocr_app/services/random_id_generator.dart';

class ResultData {
  String userId;
  String testId;
  String resultId;
  int result;
  String status;
  DateTime submittedAt;

  ResultData({
    String? resultId,
    this.userId = '',
    this.testId = '',
    this.result = 0,
    this.status = 'In Progress',
    DateTime? submittedAt,
  }) : resultId = resultId ?? RandomIdGenerator.generateResultId(),
       submittedAt = submittedAt ?? DateTime.now();
}
