import 'package:flutter/material.dart';

class DraggableDrawer extends StatefulWidget {
  final double initialSize;
  final Widget child;

  const DraggableDrawer({
    Key? key,
    required this.initialSize,
    required this.child,
  }) : super(key: key);

  @override
  _DraggableDrawerState createState() => _DraggableDrawerState();
}

class _DraggableDrawerState extends State<DraggableDrawer> {
  double _childSize = 0.3; // Initial size of the drawer
  double _dragStart = 0.0;
  final double _maxHeightFraction = 0.8; // Maximum height of the drawer (80% of screen height)
  final double _minHeightFraction = 0.1; // Minimum height of the drawer (10% of screen height)
  bool _isScrollable = false; // Flag to enable scroll when drawer is fully expanded

  @override
  void initState() {
    super.initState();
    _childSize = widget.initialSize;
  }

  @override
  Widget build(BuildContext context) {
    final double drawerHeight = MediaQuery.of(context).size.height * _childSize;

    // Check if drawer has reached max height
    if (drawerHeight >= MediaQuery.of(context).size.height * _maxHeightFraction) {
      if (!_isScrollable) {
        setState(() {
          _isScrollable = true;
        });
      }
    } else {
      if (_isScrollable) {
        setState(() {
          _isScrollable = false;
        });
      }
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onVerticalDragStart: (details) {
          _dragStart = details.localPosition.dy;
        },
        onVerticalDragUpdate: (details) {
          setState(() {
            // Reverse the direction of drag movement
            double delta = _dragStart - details.localPosition.dy; // Inverted delta
            double newSize = _childSize + delta / MediaQuery.of(context).size.height;
            _childSize = newSize.clamp(_minHeightFraction, _maxHeightFraction); // Ensure the size stays within bounds
            _dragStart = details.localPosition.dy; // Update drag position
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height * _childSize,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Column(
            children: [
              // Handle for dragging (user-friendly)
              Container(
                height: 10, // Height of the handle
                width: 80, // Width of the handle
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Scrollable content: only scroll when the drawer reaches max height
              Expanded(
                child: _isScrollable
                    ? SingleChildScrollView(
                  child: widget.child,
                )
                    : widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
