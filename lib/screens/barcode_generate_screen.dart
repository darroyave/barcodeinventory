import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

import '../controllers/barcode_controller.dart';
import '../utils/color_resources.dart';
import '../utils/dimensions.dart';
import '../utils/styles.dart';
import '../widgets/custom_app_bar_widget.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_field_with_title_widget.dart';
import '../widgets/custom_header_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/images.dart';

class BarCodeGenerateScreen extends StatelessWidget {
  const BarCodeGenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("bar_code_generator"),
      ),
      body: GetBuilder<BarcodeController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeDefault),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('code: '),
                          Text(
                            'productCode',
                            style: fontSizeRegular.copyWith(
                                color: Theme.of(context).hintColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text('product_name: '),
                          Expanded(
                            child: Text(
                              'title',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: fontSizeRegular.copyWith(
                                  color: Theme.of(context).hintColor),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                CustomFieldWithTitleWidget(
                  limitSet: true,
                  setLimitTitle: 'maximum_quantity_270',
                  customTextField: CustomTextFieldWidget(
                      hintText: 'sku_hint',
                      controller: controller.quantityController),
                  title: 'qty',
                  requiredField: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: Dimensions.fontSizeSmall),
                    Expanded(
                      child: CustomButtonWidget(
                        buttonText: 'generate',
                        onPressed: controller.generatePDF,
                      ),
                    ),
                    const SizedBox(width: Dimensions.fontSizeSmall),
                    Expanded(
                      child: CustomButtonWidget(
                        buttonText: 'download',
                        onPressed: () {},
                        buttonColor: ColorResources.colorPrint,
                      ),
                    ),
                    const SizedBox(width: Dimensions.fontSizeSmall),
                    Expanded(
                      child: CustomButtonWidget(
                        buttonText: 'reset',
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
