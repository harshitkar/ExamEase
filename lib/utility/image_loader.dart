import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageLoader {
  /// Loads the dimensions of an image file and returns its size as [Size].
  /// Returns `null` if the image cannot be decoded.
  static Future<Size?> loadImageDimensions(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(Uint8List.fromList(bytes));
      if (image != null) {
        return Size(image.width.toDouble(), image.height.toDouble());
      }
    } catch (e) {
      print('Error loading image dimensions: $e');
    }
    return null;
  }
}