import 'package:flutter/material.dart';
import 'dart:io';
import 'selection_rectangle.dart';

class ImageInteractiveViewer extends StatelessWidget {
  final File imageFile;
  final GlobalKey interactiveViewerKey;
  final TransformationController transformationController;
  final Rect? selectionRect;
  final void Function(Rect updatedRect) onRectUpdated;
  final void Function(Offset position) onImageTap;

  const ImageInteractiveViewer({
    Key? key,
    required this.imageFile,
    required this.interactiveViewerKey,
    required this.transformationController,
    required this.selectionRect,
    required this.onRectUpdated,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => onImageTap(details.localPosition),
      child: InteractiveViewer(
        key: interactiveViewerKey,
        transformationController: transformationController,
        panEnabled: true,
        scaleEnabled: true,
        child: Stack(
          children: [
            Image.file(
              imageFile,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 170,
            ),
            if (selectionRect != null)
              SelectionRectangle(
                initialRect: selectionRect ?? Rect.zero,
                onRectUpdated: onRectUpdated,
                onDone: () {}, // Extraction logic elsewhere
              ),
          ],
        ),
      ),
    );
  }
}
