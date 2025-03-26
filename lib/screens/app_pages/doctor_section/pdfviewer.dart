import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewer extends StatefulWidget {
  final String? filePath;
  const PdfViewer({super.key, this.filePath});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PDFView(
            filePath: widget.filePath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
          ),
          Positioned(
            top: 40,
            left: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white.withOpacity(0.7),
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
