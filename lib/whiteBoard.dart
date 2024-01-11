// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names, unused_element, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';
import 'pdf_api.dart';
import 'pdf_view.dart';

//  Triangle draw
class Triangle extends PaintContent {
  Triangle();

  Triangle.data({
    required this.startPoint,
    required this.A,
    required this.B,
    required this.C,
    required Paint paint,
  }) : super.paint(paint);

  factory Triangle.fromJson(Map<String, dynamic> data) {
    return Triangle.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      A: jsonToOffset(data['A'] as Map<String, dynamic>),
      B: jsonToOffset(data['B'] as Map<String, dynamic>),
      C: jsonToOffset(data['C'] as Map<String, dynamic>),
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  Offset startPoint = Offset.zero;

  Offset A = Offset.zero;
  Offset B = Offset.zero;
  Offset C = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) {
    A = Offset(
        startPoint.dx + (nowPoint.dx - startPoint.dx) / 2, startPoint.dy);
    B = Offset(startPoint.dx, nowPoint.dy);
    C = nowPoint;
  }

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final Path path = Path()
      ..moveTo(A.dx, A.dy)
      ..lineTo(B.dx, B.dy)
      ..lineTo(C.dx, C.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  Triangle copy() => Triangle();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'A': A.toJson(),
      'B': B.toJson(),
      'C': C.toJson(),
      'paint': paint.toJson(),
    };
  }
}

class WhiteBoard extends StatefulWidget {
  const WhiteBoard({
    Key? key,
  }) : super(key: key);
  static const String id = 'White Board';
  @override
  State<WhiteBoard> createState() => _WhiteBoardState();
}

class _WhiteBoardState extends State<WhiteBoard> {
  final DrawingController _drawingController = DrawingController();

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('WhiteBoard'),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
            icon: Icon(Icons.file_copy),
            onPressed: () async {
              final file = await getPathPDF.pickFile();
              if (file == null) return;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PdfView(file: file)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return DrawingBoard(
                  controller: _drawingController,
                  background: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    color: Colors.white,
                  ),
                  showDefaultActions: true,
                  showDefaultTools: true,
                  defaultToolsBuilder: (Type t, _) {
                    return DrawingBoard.defaultTools(t, _drawingController)
                      ..insert(
                        1,
                        DefToolItem(
                          icon: Icons.change_history_rounded,
                          isActive: t == Triangle,
                          onTap: () =>
                              _drawingController.setPaintContent(Triangle()),
                        ),
                      );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
