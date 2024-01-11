// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_brace_in_string_interps, avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/whiteBoard2.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'pdf_api.dart';

class PdfView extends StatefulWidget {
  const PdfView({
    Key? key,
    required this.file,
  }) : super(key: key);
  final File file;
  static const String id = 'pdf view';
  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  int pages = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.change_circle),
          onPressed: () async {
            final file = await getPathPDF.pickFile();

            if (file == null) return;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PdfView(file: file)),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => WhiteBoard2(
                          file: widget.file,
                          totalPage: pages,
                        )),
              );
            },
          )
        ],
      ),
      body: Center(
        child: PDFView(
          filePath: widget.file.path,
          autoSpacing: false,
          swipeHorizontal: false,
          pageSnap: false,
          pageFling: false,
          onRender: (pages) {
            setState(() => this.pages = pages!);
            print('sssssssssssssssssssss=============${pages}');
          },
        ),
      ),
    );
  }
}
