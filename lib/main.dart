// ignore_for_file: unused_local_variable, unused_element, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'whiteBoard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WhiteBoard(),
    );
  }
}
