import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;

class BarcodeController extends GetxController implements GetxService {
  final quantityController = TextEditingController();

  int _barCodeQuantity = 0;
  int get barCodeQuantity => _barCodeQuantity;

  Uint8List? _generatedPDFBytes;
  Uint8List? get generatedPDFBytes => _generatedPDFBytes;

  void setBarCodeQuantity(int quantity) {
    _barCodeQuantity = quantity;
    update();
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'PDF Barcode',
                  style: const pw.TextStyle(fontSize: 40),
                ),
                pw.Text(
                  'Este es un ejemplo de PDF generado con Flutter y la biblioteca pdf.',
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );

    _generatedPDFBytes = await pdf.save();
    update();
  }
}
