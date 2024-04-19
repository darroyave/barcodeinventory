import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../utils/color_resources.dart';
import '../utils/dimensions.dart';
import '../utils/styles.dart';
import '../widgets/custom_app_bar_widget.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_field_with_title_widget.dart';
import '../widgets/custom_header_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/images.dart';

class BarCodeGenerateScreen extends StatefulWidget {
  const BarCodeGenerateScreen({super.key});

  @override
  State<BarCodeGenerateScreen> createState() => _BarCodeGenerateScreenState();
}

class _BarCodeGenerateScreenState extends State<BarCodeGenerateScreen> {
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      body: GetBuilder<ProductController>(
        builder: (barCodeController) {
          return Column(
            children: [
              const CustomHeaderWidget(
                title: 'bar_code_generator',
                headerImage: Images.barCodeGenerate,
              ),
              Column(
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
                        hintText: 'sku_hint', controller: quantityController),
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
                          onPressed: () {
                            barCodeController.setBarCodeQuantity(
                                int.parse(quantityController.text));
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.fontSizeSmall),
                      Expanded(
                        child: CustomButtonWidget(
                          buttonText: 'download',
                          onPressed: () async {},
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
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                  ),
                  child: Placeholder(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
