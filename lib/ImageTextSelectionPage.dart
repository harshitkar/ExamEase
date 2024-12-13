import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'selection_rectangle.dart';

class ImageTextSelectionPage extends StatefulWidget {
  final File imageFile;

  const ImageTextSelectionPage({super.key, required this.imageFile});

  @override
  State<ImageTextSelectionPage> createState() => _ImageTextSelectionPageState();
}

class _ImageTextSelectionPageState extends State<ImageTextSelectionPage> {
  String _selectedText = '';
  List<TextBlock> _textBlocks = [];
  final TransformationController _transformationController = TransformationController();
  late Size _originalImageSize;
  late GlobalKey _interactiveViewerKey;
  bool _isImageSizeLoaded = false;
  TextEditingController _textController = TextEditingController();
  Rect? _selectionRect;

  late img.Image _image;
  bool _isDoneClicked = false; // Flag to track if "Done" is clicked

  @override
  void initState() {
    super.initState();
    _interactiveViewerKey = GlobalKey();
    _loadImageDimensions();
    _extractTextFromImage();
  }

  Future<void> _loadImageDimensions() async {
    final bytes = await widget.imageFile.readAsBytes();
    final image = img.decodeImage(Uint8List.fromList(bytes));
    if (image != null) {
      setState(() {
        _image = image;
        _originalImageSize = Size(image.width.toDouble(), image.height.toDouble());
        _isImageSizeLoaded = true;
      });
    }
  }

  Future<void> _extractTextFromImage() async {
    final inputImage = InputImage.fromFile(widget.imageFile);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      _textBlocks = recognizedText.blocks;
    });

    textRecognizer.close();
  }

  Rect _mapBoxToDisplayedImage(Rect originalBox) {
    if (!_isImageSizeLoaded) {
      return Rect.zero;
    }

    final RenderBox? renderBox = _interactiveViewerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return Rect.zero;
    }

    final Size displayedSize = renderBox.size;

    final double scaleX = displayedSize.width / _originalImageSize.width;
    final double scaleY = displayedSize.height / _originalImageSize.height;

    return Rect.fromLTRB(
      originalBox.left * scaleX,
      originalBox.top * scaleY,
      originalBox.right * scaleX,
      originalBox.bottom * scaleY,
    );
  }

  void _onRectUpdated(Rect updatedRect) {
    // Update the selection rectangle without triggering text extraction
    setState(() {
      _selectionRect = updatedRect;
    });
  }

  void _onDone() {
    if (_selectionRect != null) {
      setState(() {
        _isDoneClicked = true; // Enable text extraction

        // Clear the text box before writing new text
        _textController.clear(); // This will clear the existing text

        _selectedText = _getSelectedText(); // Get the selected text
        _textController.text = _selectedText; // Set the selected text to the text controller

        _selectionRect = null; // Clear the selection rectangle
        _isDoneClicked = false; // Reset the flag after extracting text
      });
    }
  }

  String _getSelectedText() {
    if (!_isDoneClicked || _selectionRect == null) return ''; // Ensure text is extracted only on "Done"
    String selectedText = '';
    for (TextBlock block in _textBlocks) {
      final blockRect = _mapBoxToDisplayedImage(block.boundingBox);
      if (blockRect.overlaps(_selectionRect!)) {
        selectedText += block.text + ' ';
      }
    }
    return selectedText.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Selection from Image'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTapDown: (details) {
                final imagePosition = details.localPosition;
                setState(() {
                  _selectionRect = Rect.fromLTWH(
                    imagePosition.dx,
                    imagePosition.dy,
                    100.0, // Default width
                    50.0,  // Default height
                  );
                });
              },
              child: InteractiveViewer(
                key: _interactiveViewerKey,
                transformationController: _transformationController,
                panEnabled: true,
                scaleEnabled: true,
                child: Stack(
                  children: [
                    Image.file(
                      widget.imageFile,
                      width: MediaQuery.of(context).size.width,
                    ),
                    if (_selectionRect != null)
                      SelectionRectangle(
                        initialRect: _selectionRect ?? Rect.zero,
                        onRectUpdated: _onRectUpdated,
                        onDone: () {}, // Do nothing here; extraction happens only on "Done"
                      ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.black),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _onDone,
                    child: const Text('Done'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Selected Text',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
