import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_app/pages/image_text_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageTextSelectionPage(imageFile: _selectedImage!),
        ),
      );
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      // String pdfPath = result.files.single.path!;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PdfTextSelectionPage(pdfPath: pdfPath),
      //   ),
      // );
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Text Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.camera),
              child: const Text('Capture Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: const Text('Pick from Gallery'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickPdf,
              child: const Text('Extract from PDF'),
            ),
          ],
        ),
      ),
    );
  }
}