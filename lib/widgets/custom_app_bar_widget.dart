import 'package:barcodeinventory/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/dimensions.dart';
import 'custom_on_tap_widget.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isBackButtonExist;
  const CustomAppBarWidget({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      titleSpacing: 0,
      elevation: 5,
      leadingWidth: isBackButtonExist ? 50 : 120,
      leading: isBackButtonExist
          ? Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall),
              child: CustomOnTapWidget(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back_sharp,
                    color: Theme.of(context).primaryColor, size: 25),
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.only(left: Dimensions.fontSizeExtraSmall),
              child: InkWell(
                onTap: () {},
                child: Image.asset(Images.logoWithName, width: 120, height: 30),
              ),
            ),
      title: const Text(''),
    );
  }

  @override
  Size get preferredSize =>
      Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 70 : 50);
}
