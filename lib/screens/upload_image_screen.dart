import 'package:barcodeinventory/controllers/upload_controller.dart';
import 'package:barcodeinventory/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/color_resources.dart';
import '../widgets/custom_button_widget.dart';

class UploadImageScreen extends StatelessWidget {
  const UploadImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppbar(
          title: 'Remove Backround',
          scaffoldKey: scaffoldKey,
        ),
      ),
      body: GetBuilder<UploadController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              TextFormField(
                controller: controller.productController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  hintText: "Now Press Image and scan Product",
                  hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                  labelText: 'Scan Product',
                  prefixIcon: IconButton(
                    color: Colors.teal,
                    onPressed: () async {},
                    icon: const Icon(Icons.clear),
                  ),
                  suffixIcon: IconButton(
                    color: Colors.teal,
                    onPressed: () async {},
                    icon: const Icon(Icons.search),
                  ),
                ),
                onFieldSubmitted: controller.searchProduct,
              ),
              const SizedBox(height: 12.0),
              CustomButtonWidget(
                isLoading: controller.isLoadingGallery,
                buttonText: "Select image from gallery",
                onPressed: controller.pickImageFromGallery,
              ),
              const SizedBox(height: 10),
              CustomButtonWidget(
                isLoading: controller.isLoadingCamera,
                buttonText: "Take photo",
                onPressed: controller.pickImageFromCamera,
                buttonColor: ColorResources.colorPrint,
              ),
              controller.imageBytes != null
                  ? Image.memory(
                      controller.imageBytes!,
                      height: 200,
                    )
                  : const Text('Select an image'),
            ],
          ),
        );
      }),
    );
  }
}
