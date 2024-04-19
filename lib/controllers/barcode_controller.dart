import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;

class BarcodeController extends GetxController implements GetxService {
  final upcController = TextEditingController();
  final quantityController = TextEditingController();

  Uint8List? _generatedPDFBytes;
  Uint8List? get generatedPDFBytes => _generatedPDFBytes;

  Future<void> generatePDF(int quantity, String upc) async {
    final pdf = pw.Document();

    final List<pw.Widget> barcodes = [];

    for (int i = 0; i < quantity; i++) {
      barcodes.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 10.0),
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.upcA(),
            data: upc,
            width: 200,
            height: 80,
          ),
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: barcodes,
            ),
          );
        },
      ),
    );

    _generatedPDFBytes = await pdf.save();
    update();
  }
}
