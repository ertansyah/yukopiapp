import 'package:yukopiapps/controller/menu_model.dart';

class CartModel {
  dynamic menuId;
  int quantity;
  MenuModel menu; // Tambahkan field menu untuk menyimpan data menu terkait

  CartModel({
    required this.menuId,
    required this.quantity,
    required this.menu,
  });
}
