import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yukopiapps/controller/db_services.dart';

class MenuModel {
  late String id;
  late String name;
  late int price;
  late String description;
  late String full_description;
  late String image;

  MenuModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.full_description,
    required this.image,
  });

  factory MenuModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MenuModel(
      id: doc.id,
      name: data['name'],
      price: data['price'],
      description: data['description'],
      full_description: data['full_description'],
      image: data['image'],
    );
  }

  static Future<MenuModel> getMenu(int menuId) async {
    DocumentSnapshot doc = await DbServices.getMenuList(menuId.toString());
    MenuModel menu = MenuModel.fromFirestore(doc);
    return menu;
  }
}
