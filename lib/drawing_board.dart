import 'package:flutter/material.dart';

/// ==========================
/// Stroke Model
/// ==========================
class DrawingStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final bool isEraser;

  DrawingStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  });
}

class StickyNote {
  Offset position;
  String? text;
  final TextEditingController controller;

  StickyNote({required this.position, this.text})
    : controller = TextEditingController(text: text ?? "");
}

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  List<DrawingStroke> strokes = [];
  List<DrawingStroke> undoStack = [];

  List<Offset> currentPoints = [];

  List<StickyNote> notes = [];

  Color selectedColor = Colors.black;
  double brushSize = 4.0;
  bool isEraser = false;

  Offset? pointerPosition;

  void _undo() {
    if (strokes.isEmpty) return;

    setState(() {
      undoStack.add(strokes.removeLast());
    });
  }

  void _redo() {
    if (undoStack.isEmpty) return;

    setState(() {
      strokes.add(undoStack.removeLast());
    });
  }

  void _clearCanvas() {
    setState(() {
      strokes.clear();
      undoStack.clear();
      notes.clear();
    });
  }

  void _addStickyNote() {
    setState(() {
      notes.add(StickyNote(position: const Offset(200, 200)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drawing Board"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildToolbar(),
          const Divider(height: 1),

          Expanded(
            child: Stack(
              children: [
                InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: SizedBox(
                    width: 2000,
                    height: 2000,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onPanStart: (details) {
                            setState(() {
                              pointerPosition = details.localPosition;
                              currentPoints = [details.localPosition];
                            });
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              pointerPosition = details.localPosition;
                              currentPoints.add(details.localPosition);
                            });
                          },
                          onPanEnd: (_) {
                            setState(() {
                              strokes.add(
                                DrawingStroke(
                                  points: List.from(currentPoints),
                                  color: selectedColor,
                                  strokeWidth: brushSize,
                                  isEraser: isEraser,
                                ),
                              );

                              currentPoints.clear();
                              pointerPosition = null;
                              undoStack.clear();
                            });
                          },
                          child: CustomPaint(
                            size: const Size(2000, 2000),
                            painter: DrawingPainter(
                              strokes: strokes,
                              currentPoints: currentPoints,
                              selectedColor: selectedColor,
                              brushSize: brushSize,
                              isEraser: isEraser,
                              pointerPosition: pointerPosition,
                            ),
                          ),
                        ),

                        ...notes.map((note) {
                          return Positioned(
                            left: note.position.dx,
                            top: note.position.dy,
                            child: _buildStickyNote(note),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Wrap(
            spacing: 4,
            children: [
              IconButton(icon: const Icon(Icons.undo), onPressed: _undo),
              IconButton(icon: const Icon(Icons.redo), onPressed: _redo),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _clearCanvas,
              ),

              /// Brush
              IconButton(
                icon: const Icon(Icons.brush),
                color: !isEraser ? Colors.blue : null,
                onPressed: () {
                  setState(() {
                    isEraser = false;
                    selectedColor = Colors.black;
                  });
                },
              ),

              IconButton(
                icon: const Icon(Icons.not_interested),
                color: isEraser ? Colors.blue : null,
                onPressed: () {
                  setState(() {
                    isEraser = true;
                  });
                },
              ),

              IconButton(
                icon: const Icon(Icons.note_add),
                onPressed: _addStickyNote,
              ),
            ],
          ),

          Row(
            children: [
              Text("Size", style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),

              SizedBox(
                width: 30,
                height: 40,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: brushSize,
                    height: brushSize,
                    decoration: BoxDecoration(
                      color: isEraser ? Colors.white : selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black26),
                      boxShadow: const [
                        BoxShadow(blurRadius: 3, color: Colors.black26),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Slider(
                  min: 1,
                  max: 30,
                  value: brushSize,
                  onChanged: (value) {
                    setState(() {
                      brushSize = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyNote(StickyNote note) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          note.position += details.delta;
        });
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.yellow.shade200,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// Delete Button
            GestureDetector(
              onTap: () {
                setState(() {
                  note.controller.dispose();
                  notes.remove(note);
                });
              },
              child: const Icon(Icons.close, size: 18),
            ),

            TextField(
              controller: note.controller,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "New Sticky Note",
              ),
              onChanged: (value) {
                note.text = value.isEmpty ? null : value;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final List<Offset> currentPoints;
  final Color selectedColor;
  final double brushSize;
  final bool isEraser;
  final Offset? pointerPosition;

  DrawingPainter({
    required this.strokes,
    required this.currentPoints,
    required this.selectedColor,
    required this.brushSize,
    required this.isEraser,
    required this.pointerPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }

    _drawCurrentStroke(canvas);

    /// Floating brush preview
    if (pointerPosition != null) {
      final previewPaint = Paint()
        ..color = isEraser ? Colors.black : Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(pointerPosition!, brushSize / 2, previewPaint);
    }
  }

  void _drawStroke(Canvas canvas, DrawingStroke stroke) {
    final paint = Paint()
      ..color = stroke.isEraser ? Colors.white : stroke.color
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < stroke.points.length - 1; i++) {
      canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
    }
  }

  void _drawCurrentStroke(Canvas canvas) {
    if (currentPoints.length < 2) return;

    final paint = Paint()
      ..color = isEraser ? Colors.white : selectedColor
      ..strokeWidth = brushSize
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < currentPoints.length - 1; i++) {
      canvas.drawLine(currentPoints[i], currentPoints[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
