import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextRecognitionService {
  /// Extracts text blocks from an image file using the specified script.
  static Future<List<TextBlock>> extractTextBlocks(File imageFile) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.devanagiri);

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      return recognizedText.blocks;
    } catch (e) {
      print('Error during text recognition: $e');
      return [];
    } finally {
      textRecognizer.close();
    }
  }
}
