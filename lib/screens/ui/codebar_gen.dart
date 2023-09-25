import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class CodeBarGen extends StatefulWidget {
  const CodeBarGen({super.key});

  @override
  State<CodeBarGen> createState() => _CodeBarGenState();
}

class _CodeBarGenState extends State<CodeBarGen> {
  String result = '';
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 24,
            ),
            Card(
              color: Colors.white,
              elevation: 5,
              shadowColor: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BarcodeWidget(
                  textPadding: 20,
                  drawText: false,
                  barcode: Barcode.code128(), // Barcode type and settings
                  data: controller.text,
                  style: const TextStyle(
                      fontSize: 20, color: Colors.red), // Content
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Text(controller.text),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: buildTextField(context),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromWidth(250),
                elevation: 1,
              ),
              icon: const Icon(Icons.print),
              label: const Text('PRINT LABEL'),
              onPressed: () {},
            ),
            ElevatedButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  if (res is String) {
                    result = res;
                  }
                });
              },
              child: const Text('Open Scanner'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context) => TextField(
        decoration: InputDecoration(
          helperMaxLines: 12,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'SCAN CODEBAR',
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          labelText: 'Scan code',
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              controller.clear();
            },
            icon: const Icon(
              Icons.clear,
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        style: const TextStyle(
            fontFamily: 'roboto',
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500),
        controller: controller,
        onSubmitted: (_) => setState(() {}),
      );
}
