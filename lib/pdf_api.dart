// ignore_for_file: camel_case_types

import 'dart:async';
import 'package:file_picker/file_picker.dart';

import 'dart:io';

// use File_Picker to get path PDF local
class getPathPDF {
  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return null;
    return File(result.paths.first!);
  }
}
