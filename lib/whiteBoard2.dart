// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names, unused_element

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'custom_listview_pdf.dart';

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

class WhiteBoard2 extends StatefulWidget {
  const WhiteBoard2({
    Key? key,
    required this.totalPage,
    required this.file,
  }) : super(key: key);
  final int totalPage;
  final File file;

  static const String id = 'White Board with pdf';
  @override
  State<WhiteBoard2> createState() => _WhiteBoard2State();
}

class _WhiteBoard2State extends State<WhiteBoard2> {
  final DrawingController _drawingController = DrawingController();
  PDFViewController? controller;
  int pages = 0;
  int indexPage = 0;
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return DrawingBoard(
                  // boardPanEnabled: false,
                  controller: _drawingController,
                  background: ListPdfPage(
                      file: widget.file,
                      width: constraints.maxWidth,
                      pages: widget.totalPage)!,
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
