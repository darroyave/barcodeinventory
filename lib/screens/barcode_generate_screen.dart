import 'package:barcodeinventory/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

import '../controllers/barcode_controller.dart';
import '../utils/color_resources.dart';
import '../utils/dimensions.dart';
import '../widgets/custom_button_widget.dart';

class BarCodeGenerateScreen extends StatelessWidget {
  const BarCodeGenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppbar(
          title: 'Barcode Generator',
          scaffoldKey: scaffoldKey,
        ),
      ),
      body: GetBuilder<BarcodeController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: controller.productController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.teal),
                    ),
                    hintText: "Now Press Image and scan Product",
                    hintStyle:
                        const TextStyle(fontSize: 16, color: Colors.grey),
                    labelText: 'Scan Product',
                    prefixIcon: IconButton(
                      color: Colors.teal,
                      onPressed: controller.clearData,
                      icon: const Icon(Icons.clear),
                    ),
                    suffixIcon: IconButton(
                      color: Colors.teal,
                      onPressed: () => controller
                          .searchProduct(controller.productController.text),
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  onFieldSubmitted: controller.searchProduct,
                ),
                const SizedBox(height: 20),
                Text("Product: ${controller.productName}"),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: Dimensions.fontSizeSmall),
                    Expanded(
                      child: CustomButtonWidget(
                          buttonText: 'Generate',
                          onPressed: () {
                            int quantity = int.parse(
                                "0${controller.quantityController.text}");
                            String upc = controller.productController.text;
                            if (quantity > 0 && upc.isNotEmpty) {
                              controller.generatePDF(quantity, upc);
                            }
                          }),
                    ),
                    const SizedBox(width: Dimensions.fontSizeSmall),
                    Expanded(
                      child: CustomButtonWidget(
                        buttonText: 'Print',
                        onPressed: controller.printPDF,
                        buttonColor: ColorResources.colorPrint,
                      ),
                    ),
                    const SizedBox(width: Dimensions.fontSizeSmall),
                    Expanded(
                      child: CustomButtonWidget(
                        buttonText: 'Reset',
                        onPressed: () {},
                        buttonColor: ColorResources.getResetColor(),
                        textColor: ColorResources.getTextColor(),
                        isClear: true,
                      ),
                    ),
                    const SizedBox(width: Dimensions.fontSizeSmall),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                if (controller.generatedPDFBytes != null)
                  Expanded(
                    child: PDFView(
                      filePath: null,
                      pdfData: controller.generatedPDFBytes,
                      enableSwipe: true,
                      swipeHorizontal: true,
                      autoSpacing: false,
                      pageFling: false,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
