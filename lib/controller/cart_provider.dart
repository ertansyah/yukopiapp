import 'package:flutter/material.dart';
import 'package:yukopiapps/controller/menu_model.dart';
import 'package:yukopiapps/modules/cart_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartModel> _cart = [];
  List<CartModel> get cart => _cart;
  int _total = 0;
  int get total => _total;
  int calculateTotal() {
    int totalPrice = 0;
    for (var item in _cart) {
      totalPrice += item.menu.price * item.quantity;
    }
    return totalPrice;
  }

  void resetCart() {
    cart.clear();
  }

  void addRemove(int menuId, bool isAdd, [int? index]) {
    if (isAdd) {
      // Logika penambahan item
      if (_cart.where((element) => menuId == element.menuId).isNotEmpty) {
        // Sudah mengandung id yang diklik
        index = _cart.indexWhere((element) => element.menuId == menuId);
        _cart[index].quantity++;
        _total++;
      } else {
        // Belum ada
        MenuModel menu = MenuModel(
          id: '',
          name: '',
          price: 0,
          description: '',
          full_description: '',
          image: '',
        );
        _cart.add(CartModel(menuId: menuId, quantity: 1, menu: menu));
        _total++;
      }
    } else {
      // Logika pengurangan item
      if (index != null && _cart.isNotEmpty) {
        var item = _cart.firstWhere(
          (element) => element.menuId == menuId,
          orElse: () => CartModel(
            menuId: -1,
            quantity: 0,
            menu: MenuModel(
              id: '',
              name: '',
              price: 0,
              description: '',
              full_description: '',
              image: '',
            ),
          ),
        );
        if (item.menuId != -1) {
          if (item.quantity > 1) {
            item.quantity--;
            _total--;
          } else {
            _cart.remove(item);
            _total--;
          }
        }
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _total = 0;
    notifyListeners();
  }

  // Fungsi untuk mengupdate nomor meja

  // Fungsi untuk mencetak ID dan jumlah klik
  void printClickCount(int menuId) {
    var item = _cart.firstWhere(
      (element) => element.menuId == menuId,
      orElse: () => CartModel(
        menuId: -1,
        quantity: 0,
        menu: MenuModel(
          id: '',
          name: '',
          price: 0,
          description: '',
          full_description: '',
          image: '',
        ),
      ),
    );
    if (item.menuId != -1) {
      print("Menu ID: $menuId");
      print("Jumlah klik: ${item.quantity}");
    }
  }
}
