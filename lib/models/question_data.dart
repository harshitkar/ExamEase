import 'dart:typed_data';

import 'package:ocr_app/services/random_id_generator.dart';

import 'option_data.dart';

class QuestionData {
  String questionId;
  String questionText;
  Uint8List? questionImage;
  List<OptionData> options;
  int questionNumber;
  int correctOptionIndex;

  QuestionData({
    String? questionId,
    this.questionText = '',
    this.questionImage,
    List<OptionData>? options,
    this.questionNumber = 0,
    this.correctOptionIndex = 0,
  }) : questionId = questionId ?? RandomIdGenerator.generateQuestionId(),
  options = options ?? List.generate(4, (index) => OptionData(optionNumber: index + 1));
}