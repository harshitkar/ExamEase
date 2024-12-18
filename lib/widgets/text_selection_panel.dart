import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'selection_row.dart';
import 'draggable_drawer.dart';

class TextSelectionPanelDrawer extends StatelessWidget {
  final List<TextEditingController> textControllers;
  final List<Uint8List?> images;
  final List<VoidCallback> onSelectTextCallbacks;
  final List<VoidCallback> onCaptureImageCallbacks;

  const TextSelectionPanelDrawer({
    Key? key,
    required this.textControllers,
    required this.images,
    required this.onSelectTextCallbacks,
    required this.onCaptureImageCallbacks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableDrawer(
      initialSize: 0.3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (int i = 0; i < 5; i++) ...[
              SelectionRow(
                text: i == 0 ? 'Question' : 'Option $i',
                textController: textControllers[i],
                image: images[i],
                onSelectText: onSelectTextCallbacks[i],
                onCaptureImage: onCaptureImageCallbacks[i],
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
