import 'dart:typed_data';
import 'package:flutter/material.dart';

class SelectionRow extends StatelessWidget {
  final String text;
  final TextEditingController textController;
  final Uint8List? image; // Image data
  final VoidCallback onSelectText;
  final VoidCallback onCaptureImage;

  const SelectionRow({
    Key? key,
    required this.text,
    required this.textController,
    required this.image,
    required this.onSelectText,
    required this.onCaptureImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: onSelectText, child: const Text('Extract Text')),
            ElevatedButton(onPressed: onCaptureImage, child: Text((image == null) ? 'Crop Image' : 'Delete Image')),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Selected Text',
          ),
        ),
        const SizedBox(height: 8),
        if (image != null)
          Image.memory(
              image!,
              width: double.infinity,
              fit: BoxFit.contain,
            )
      ],
    );
  }
}
