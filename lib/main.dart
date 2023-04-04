import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_editor/pdf_editor.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  PdfEditorController controller = PdfEditorController();
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: PdfEditor(
        controller: controller,
        loadPdf: () async {
          // var file = File(r'C:\src\pdfform.js_generated.pdf'); // -> ERROR
          // var file = File(r'C:\src\prova pdf.pdf'); // -> Revisar (funciona però és veu raro)
          // var file = File(r'C:\src\PDFControlQualitat.pdf'); // -> Ok
          // var file = File(r'C:\src\ProvaEditOF.pdf'); // -> Ok

          // var file = File(r'C:\src\radiobutton.pdf'); // -> No funciona molt bé
          var directory = Directory('/storage/emulated/0/Download');
          var file = File(r'/storage/emulated/0/Download/level1_v1.0.1.pdf'); //
          // var file = File(r'C:\src\level1_v1.0.1.pdf'); //
          var bytes = await file.readAsBytes();
          return bytes;
        },
        savePdf: (data) async {
          File("C:\\src\\p2.pdf").writeAsBytes(data);
        },
      ),
    );
  }
}
