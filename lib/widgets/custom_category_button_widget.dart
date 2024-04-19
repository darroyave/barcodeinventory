import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import '../utils/gradient_color_helper.dart';
import '../utils/styles.dart';
import 'custom_asset_image_widget.dart';

class CustomCategoryButtonWidget extends StatelessWidget {
  final String icon;
  final String buttonText;
  final bool isSelected;
  final double padding;
  final bool isDrawer;
  final Function? onTap;
  final bool? showDivider;
  const CustomCategoryButtonWidget({
    super.key,
    required this.icon,
    required this.buttonText,
    this.isSelected = false,
    this.padding = Dimensions.paddingSizeDefault,
    this.isDrawer = true,
    this.onTap,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap as void Function()?,
          child: Padding(
            padding: isDrawer
                ? const EdgeInsets.all(0.0)
                : const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall),
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: isDrawer
                      ? BorderRadius.zero
                      : BorderRadius.circular(Dimensions.paddingSizeSmall),
                  gradient: GradientColorHelper.gradientColor(opacity: 0.03),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: padding),
                  child: Column(children: [
                    CustomAssetImageWidget(
                      icon,
                      width: 30,
                      color: isSelected
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).primaryColor,
                    ),
                    Text(
                      buttonText,
                      style: fontSizeMedium.copyWith(
                        color: isSelected
                            ? Theme.of(context).secondaryHeaderColor
                            : Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeExtraLarge,
                      ),
                    ),
                  ]),
                )),
          ),
        ),
        if (isDrawer) Divider(height: 3, color: Theme.of(context).cardColor),
      ],
    );
  }
}
