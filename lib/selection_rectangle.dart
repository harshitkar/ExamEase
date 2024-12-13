import 'package:flutter/material.dart';

class SelectionRectangle extends StatefulWidget {
  final Rect initialRect;
  final ValueChanged<Rect> onRectUpdated;
  final VoidCallback onDone;

  const SelectionRectangle({
    Key? key,
    required this.initialRect,
    required this.onRectUpdated,
    required this.onDone,
  }) : super(key: key);

  @override
  _SelectionRectangleState createState() => _SelectionRectangleState();
}

class _SelectionRectangleState extends State<SelectionRectangle> {
  late Rect _rect;
  Offset? _dragStartOffset;
  Offset? _resizeStartOffset;

  @override
  void initState() {
    super.initState();
    _rect = widget.initialRect;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Draggable and resizable rectangle
        Positioned.fromRect(
          rect: _rect,
          child: GestureDetector(
            onPanStart: (details) {
              final localPosition = details.localPosition;
              if (_isInsideResizeHandle(localPosition)) {
                _resizeStartOffset = localPosition;
              } else {
                _dragStartOffset = details.globalPosition;
              }
            },
            onPanUpdate: (details) {
              setState(() {
                if (_resizeStartOffset != null) {
                  // Resize logic
                  final dx = details.localPosition.dx - _resizeStartOffset!.dx;
                  final dy = details.localPosition.dy - _resizeStartOffset!.dy;

                  double newWidth = _rect.width + dx;
                  double newHeight = _rect.height + dy;

                  newWidth = newWidth.clamp(32.0, screenWidth - _rect.left);
                  newHeight = newHeight.clamp(32.0, screenHeight - _rect.top);

                  _rect = Rect.fromLTWH(_rect.left, _rect.top, newWidth, newHeight);
                } else if (_dragStartOffset != null) {
                  // Drag logic
                  final dx = details.globalPosition.dx - _dragStartOffset!.dx;
                  final dy = details.globalPosition.dy - _dragStartOffset!.dy;

                  double newLeft = _rect.left + dx;
                  double newTop = _rect.top + dy;

                  newLeft = newLeft.clamp(0.0, screenWidth - _rect.width);
                  newTop = newTop.clamp(0.0, screenHeight - _rect.height);

                  _rect = Rect.fromLTWH(newLeft, newTop, _rect.width, _rect.height);
                  _dragStartOffset = details.globalPosition;
                }
              });
              widget.onRectUpdated(_rect);
            },
            onPanEnd: (_) {
              _dragStartOffset = null;
              _resizeStartOffset = null;
              widget.onDone();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        // Larger resize handle with a smaller visible element
        Positioned(
          left: _rect.right - 16,
          top: _rect.bottom - 16,
          child: GestureDetector(
            onPanStart: (details) {
              _resizeStartOffset = details.globalPosition;
            },
            onPanUpdate: (details) {
              setState(() {
                final dx = details.globalPosition.dx - _resizeStartOffset!.dx;
                final dy = details.globalPosition.dy - _resizeStartOffset!.dy;

                double newWidth = _rect.width + dx;
                double newHeight = _rect.height + dy;

                newWidth = newWidth.clamp(20.0, screenWidth - _rect.left);
                newHeight = newHeight.clamp(20.0, screenHeight - _rect.top);

                _rect = Rect.fromLTWH(_rect.left, _rect.top, newWidth, newHeight);
                _resizeStartOffset = details.globalPosition;
              });
              widget.onRectUpdated(_rect);
            },
            onPanEnd: (_) {
              _resizeStartOffset = null;
              widget.onDone();
            },
            child: Container(
              width: 40, // Touchable area size
              height: 40,
              alignment: Alignment.center,
              child: Container(
                width: 20, // Visible handle size
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Check if the touch is inside the resize handle
  bool _isInsideResizeHandle(Offset position) {
    const handleSize = 16.0;
    final handleCenter = Offset(_rect.width, _rect.height);
    final handleRect = Rect.fromCircle(center: handleCenter, radius: handleSize);
    return handleRect.contains(position);
  }
}
