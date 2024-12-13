import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OCRScreen(),
    );
  }
}

class OCRScreen extends StatefulWidget {
  const OCRScreen({Key? key}) : super(key: key);

  @override
  _OCRScreenState createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  final ImagePicker _picker = ImagePicker();
  String _extractedText = "";
  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _extractedText = "Extracting text..."; // Show progress
      });
      await _extractTextFromImage(File(pickedImage.path));
    }
  }

  Future<void> _extractTextFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    setState(() {
      _extractedText = recognizedText.text.isNotEmpty
          ? recognizedText.text
          : "No text found in the image.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _getImage(ImageSource.camera),
                  child: const Text('Capture Image'),
                ),
                ElevatedButton(
                  onPressed: () => _getImage(ImageSource.gallery),
                  child: const Text('Select from Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_image != null) ...[
              Center(
                child: Image.file(
                  _image!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _extractedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
