import 'dart:typed_data';

import 'package:ocr_app/services/random_id_generator.dart';

import 'option_data.dart';

class QuestionData {
  String questionId = "question${RandomIdGenerator.generateId()}";
  String questionText;
  Uint8List? questionImage;
  List<OptionData> options;

  QuestionData({
    this.questionText = '',
    this.questionImage,
    List<OptionData>? options,
  }) : options = options ?? List.generate(4, (_) => OptionData());
}