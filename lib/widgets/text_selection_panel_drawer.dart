import 'package:flutter/material.dart';
import 'draggable_drawer.dart'; // Import the DraggableDrawer widget

class TextSelectionPanelDrawer extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onDone;

  const TextSelectionPanelDrawer({
    Key? key,
    required this.textController,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableDrawer(
      initialSize: 0.3, // Initial size of the drawer
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: onDone,
                child: const Text('Done'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Selected Text',
                ),
              ),
            ],
          ),
        ),
    );
  }
}