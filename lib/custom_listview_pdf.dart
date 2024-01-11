// ignore_for_file: public_member_api_docs, sort_constructors_first, body_might_complete_normally_nullable, dead_code, sized_box_for_whitespace, void_checks
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

Widget? ListPdfPage(
    {required File file, required double width, required int pages}) {
  Widget? pdf;
  if (pages > 1) {
    List<Widget> listPages = [];
    for (int i = 0; i < pages; i++) {
      listPages.add(Container(
        height: 500,
        width: width,
        child: PDFView(
          filePath: file!.path,
          autoSpacing: false,
          swipeHorizontal: false,
          pageSnap: false,
          pageFling: false,
          defaultPage: i,
        ),
      ));
    }
    pdf = Column(
      children: listPages,
    );
  } else if (pages == 1) {
    pdf = Container(
      height: 500,
      width: width,
      child: PDFView(
        filePath: file!.path,
        autoSpacing: false,
        swipeHorizontal: false,
        pageSnap: false,
        pageFling: false,
        defaultPage: 0,
      ),
    );
  }
  return pdf;
}
