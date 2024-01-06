// ignore_for_file: unused_import, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/whiteBoard2.dart';
import 'custom_button.dart';
import 'pdf_api.dart';
import 'whiteBoard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static String id = 'home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'WhiteBoard',
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const WhiteBoard()),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'whiteBoard with PDF',
                onClicked: () async {
                  final file = await getPathPDF.pickFile();

                  if (file == null) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => WhiteBoard2(file: file)),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
