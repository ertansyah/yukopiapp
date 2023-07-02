import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yukopiapps/controller/menu_model.dart';
import 'package:yukopiapps/view/widget_detail_menu.dart';

class DetailMenu extends StatefulWidget {
  const DetailMenu({Key? key});

  @override
  State<DetailMenu> createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  final DbServices dbServices = DbServices();

  void navigateToDetailMenu(MenuModel menu) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuDetailScreen(
          menuId: menu.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<MenuModel>>(
              future: dbServices.getMenuData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          MenuModel menu = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: InkWell(
                                onTap: () => navigateToDetailMenu(menu),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio:
                                          1.0, // Menyamakan lebar dan tinggi
                                      child: GestureDetector(
                                        onTap: () => navigateToDetailMenu(menu),
                                        child: Image.network(
                                          menu.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 8.0,
                                        ),
                                        child: Text(
                                          menu.name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 8.0,
                                      ),
                                      child: GestureDetector(
                                        onTap: () => navigateToDetailMenu(menu),
                                        child: Text(
                                          menu.description,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      color: Colors.black.withOpacity(0.3),
                                      child: GestureDetector(
                                        onTap: () => navigateToDetailMenu(menu),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8),
                                          child: Text(
                                            'Detail Lebih lanjut',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("Tidak ada data"),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DbServices {
  static CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('menu');

  Future<List<MenuModel>> getMenuData() async {
    QuerySnapshot snapshot = await menuCollection.get();
    List<MenuModel> menuList = [];

    snapshot.docs.forEach((doc) {
      MenuModel menu = MenuModel.fromFirestore(doc);
      menuList.add(menu);
    });

    return menuList;
  }

  // Metode lainnya...
}
