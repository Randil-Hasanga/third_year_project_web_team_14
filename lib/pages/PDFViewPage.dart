import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;



Future<void> _openPDF(BuildContext context, String url) async {
  try {
    var response = await http.get(Uri.parse(url));
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(response.bodyBytes);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewPage(filePath: file.path),
      ),
    );
  } catch (e) {
    print('Error opening PDF: $e');
  }
}

class PDFViewPage extends StatelessWidget {
  final String filePath;

  PDFViewPage({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV View'),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}

