class MarksData {
  String userId;
  String testId;
  int marks;
  String status;
  DateTime submittedAt;

  MarksData({
    this.userId = '',
    this.testId = '',
    this.marks = 0,
    this.status = 'In Progress',
    DateTime? submittedAt,
  }) : submittedAt = submittedAt ?? DateTime.now();
}
