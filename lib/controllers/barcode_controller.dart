import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';

import '../models/product.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';

class BarcodeController extends GetxController implements GetxService {
  final productController = TextEditingController();
  final quantityController = TextEditingController();

  Uint8List? _generatedPDFBytes;
  Uint8List? get generatedPDFBytes => _generatedPDFBytes;

  String _productName = "";
  String get productName => _productName;

  int productId = 0;
  double productPrice = 0.0;

  final InventoryService _inventoryService = InventoryService();

  void clearData() {
    productController.clear();
    _productName = "";
    productId = 0;
    productPrice = 0.0;
    update();
  }

  Future<void> searchProduct(String barCode) async {
    http.Response response = await _inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$barCode",
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      Product? product = Product.fromJson(data);
      debugPrint(product.price.toString());

      productId = product.id;
      _productName = product.name;
      productPrice = product.price;
      update();
    } else {
      productId = 0;
      _productName = "Product doesn't exist";
      productPrice = 0.0;
      update();
    }
  }

  Future<void> generatePDF(int quantity, String upc) async {
    final pdf = pw.Document();

    for (int i = 0; i < quantity; i++) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    _productName,
                    style: const pw.TextStyle(fontSize: 30),
                  ),
                  pw.SizedBox(height: 20),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.upcA(),
                    data: upc,
                    width: 300,
                    height: 150,
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    productPrice.toString(),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    _generatedPDFBytes = await pdf.save();
    update();
  }

  Future<void> printPDF() async {
    if (_generatedPDFBytes != null) {
      await Printing.layoutPdf(onLayout: (format) async => _generatedPDFBytes!);
    }
  }
}
