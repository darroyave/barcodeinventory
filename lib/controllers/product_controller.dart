import 'package:get/get.dart';

class ProductController extends GetxController implements GetxService {
  int _barCodeQuantity = 0;
  int get barCodeQuantity => _barCodeQuantity;

  void setBarCodeQuantity(int quantity) {
    _barCodeQuantity = quantity;
    update();
  }
}
