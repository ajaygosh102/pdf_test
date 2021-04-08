import 'package:flutter/material.dart';
import 'package:pdf_flutter_app/home_page.dart';
import 'package:pdf_flutter_app/overlay_test.dart';
import 'package:pdf_flutter_app/test.dart';

import 'annotations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: PdfTest(),
    );
  }
}

class PdfTest extends StatefulWidget {
  @override
  _PdfTestState createState() => _PdfTestState();
}

class _PdfTestState extends State<PdfTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF view'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OverLayTest(),
              ),
            );
          },
          child: Text('PDF'),
        ),
      ),
    );
  }
}
