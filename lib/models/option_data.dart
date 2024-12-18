import 'dart:typed_data';

import 'package:ocr_app/services/random_id_generator.dart';

class OptionData {
  String optionId;
  String optionText;
  Uint8List? image;
  int optionNumber;

  OptionData({
    String? optionId,
    this.optionText = '',
    this.image,
    this.optionNumber = 0,
  }) : optionId = optionId ?? RandomIdGenerator.generateOptionId();
}