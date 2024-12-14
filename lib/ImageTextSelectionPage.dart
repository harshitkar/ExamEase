import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:ocr_app/utility/image_loader.dart';
import 'package:ocr_app/utility/text_recognition_service.dart';
import 'package:ocr_app/widgets/image_interactive_viewer.dart';
import 'package:ocr_app/widgets/text_selection_panel_drawer.dart';

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
    final size = await ImageLoader.loadImageDimensions(widget.imageFile);
    if (size != null) {
      setState(() {
        _originalImageSize = size;
        _isImageSizeLoaded = true;
      });
    }
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

  Future<void> _extractTextFromImage() async {
    try {
      final textBlocks = await TextRecognitionService.extractTextBlocks(widget.imageFile);
      setState(() {
        _textBlocks = textBlocks;
      });

      // Print recognized text for debugging
      for (final textBlock in _textBlocks) {
        print('Recognized Text: ${textBlock.text}');
      }
    } catch (e) {
      print('Error during text extraction: $e');
    }
  }

  void _onDone() {
    if (_selectionRect != null) {
      setState(() {
        _isDoneClicked = true; // Enable text extraction

        // Clear the text box before writing new text
        _textController.clear();

        // Get the selected text
        _selectedText = _getSelectedText();

        // Set the selected text to the text controller
        _textController.text = _selectedText;

        // Reset state
        _selectionRect = null;
        _isDoneClicked = false;
      });
    }
  }

  String _getSelectedText() {
    if (!_isDoneClicked || _selectionRect == null) return ''; // Ensure text is extracted only on "Done"
    String selectedText = '';
    for (TextBlock block in _textBlocks) {
      final blockRect = _mapBoxToDisplayedImage(block.boundingBox);
      if (blockRect.overlaps(_selectionRect!)) {
        selectedText += '${block.text} ';
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
            child: ImageInteractiveViewer(
              imageFile: widget.imageFile,
              interactiveViewerKey: _interactiveViewerKey,
              transformationController: _transformationController,
              selectionRect: _selectionRect,
              onRectUpdated: _onRectUpdated,
              onImageTap: (Offset position) {
                setState(() {
                  _selectionRect = Rect.fromLTWH(
                    position.dx,
                    position.dy,
                    100.0, // Default width
                    50.0,  // Default height
                  );
                });
              },
            ),
          ),
          TextSelectionPanelDrawer(
            textController: _textController,
            onDone: _onDone,
          ),
        ],
      ),
    );
  }
}