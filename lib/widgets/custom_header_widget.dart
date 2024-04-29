import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import '../utils/styles.dart';
import 'custom_asset_image_widget.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String headerImage;
  final String title;
  const CustomHeaderWidget(
      {super.key, required this.title, required this.headerImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      
      color: Theme.of(context).primaryColor.withOpacity(0.06),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAssetImageWidget(headerImage, height: 50),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Text(
              title,
              style: fontSizeMedium.copyWith(
                fontSize: Dimensions.fontSizeOverLarge,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
