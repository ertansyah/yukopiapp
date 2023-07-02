import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yukopiapps/controller/db_services.dart';
import 'package:yukopiapps/controller/menu_model.dart';

class MenuDetailScreen extends StatelessWidget {
  final String menuId;

  const MenuDetailScreen({Key? key, required this.menuId}) : super(key: key);

  Future<MenuModel> getMenuData() async {
    final DocumentSnapshot snapshot = await DbServices.getMenuList(menuId);
    return MenuModel.fromFirestore(snapshot);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MenuModel>(
      future: getMenuData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            final menu = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Center(
                  child: Text(
                    menu.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                backgroundColor: Colors.brown,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.network(
                        menu.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            menu.full_description,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
