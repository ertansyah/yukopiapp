import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yukopiapps/controller/menu_model.dart';

class DbServices {
  static CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('menu');

  static Future<void> createOrUpdateMenu(String id,
      {required String name,
      required int price,
      required String description,
      required String full_description,
      String? image}) async {
    await menuCollection.doc(id).set(
      {
        'name': name,
        'price': price,
        'description': description,
        'full_description': full_description,
        'image': image,
      },
      SetOptions(merge: true),
    );
  }

  static Future<DocumentSnapshot> getMenuList(String id) async {
    return await menuCollection.doc(id).get();
  }

  static Future<void> deleteMenu(String id) async {
    await menuCollection.doc(id).delete();
  }

  static Future<MenuModel?> getMenu(String id) async {
    DocumentSnapshot doc = await menuCollection.doc(id).get();
    if (doc.exists) {
      return MenuModel.fromFirestore(doc);
    } else {
      return null;
    }
  }
}
