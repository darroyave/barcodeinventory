import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  AddItemState createState() => AddItemState();
}

class AddItemState extends State<AddItem> {
  Uint8List? imageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      removeBackgroundFromBytes(bytes);
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      removeBackgroundFromBytes(bytes);
    }
  }

  Future<void> removeBackgroundFromBytes(Uint8List imageBytes) async {
    var uri = Uri.parse('https://api.remove.bg/v1.0/removebg');
    var response = await http.post(
      uri,
      headers: {
        'X-Api-Key': 'RcavZs7cJy8NndySSwkQErWK',
        'Content-Type': 'application/json',
      },
      body: json
          .encode({'image_file_b64': base64Encode(imageBytes), 'size': 'auto'}),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Fondo eliminado correctamente');
      }
      setState(() {
        this.imageBytes = response.bodyBytes;
      });
      saveImage(this.imageBytes!);
    } else {
      if (kDebugMode) {
        print('Error al eliminar el fondo: ${response.body}');
      }
    }
  }

  Future<void> saveImage(Uint8List imageBytes) async {
    final directory = await getTemporaryDirectory();
    final imagePath =
        await File('${directory.path}/removed_background.png').create();
    await imagePath.writeAsBytes(imageBytes);

    final result = await ImageGallerySaver.saveFile(imagePath.path);
    if (kDebugMode) {
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remover fondo de imagen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickImageFromGallery,
              child: const Text('Seleccionar de la galería'),
            ),
            ElevatedButton(
              onPressed: pickImageFromCamera,
              child: const Text('Tomar foto'),
            ),
            if (imageBytes != null) Image.memory(imageBytes!),
          ],
        ),
      ),
    );
  }
}
