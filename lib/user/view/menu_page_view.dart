import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yukopiapps/controller/cart_provider.dart';
import 'package:yukopiapps/controller/db_services.dart';
import 'package:yukopiapps/controller/menu_model.dart';

class MenuPageUser extends StatelessWidget {
  final DbServices dbServices = DbServices();

  MenuPageUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<List<MenuModel>>(
              stream: DbServices.menuCollection.snapshots().map(
                    (snapshot) => snapshot.docs
                        .map((doc) => MenuModel.fromFirestore(doc))
                        .toList(),
                  ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    List<MenuModel>? menuList = snapshot.data;
                    if (menuList != null && menuList.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: menuList.length,
                          itemBuilder: (context, index) {
                            MenuModel menu = menuList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(menu.image),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menu.name,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          menu.description,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Rp. ${menu.price}",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Provider.of<CartProvider>(
                                                      context,
                                                      listen: false,
                                                    ).addRemove(
                                                      int.parse(menu.id),
                                                      false,
                                                      index,
                                                    );
                                                    Provider.of<CartProvider>(
                                                      context,
                                                      listen: false,
                                                    ).printClickCount(
                                                      int.parse(menu.id),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.remove_circle,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Consumer<CartProvider>(
                                                  builder: (context, value, _) {
                                                    var id =
                                                        value.cart.indexWhere(
                                                      (element) =>
                                                          element.menuId ==
                                                          int.parse(menu.id),
                                                    );
                                                    return Text(
                                                      (id == -1)
                                                          ? "0"
                                                          : value
                                                              .cart[id].quantity
                                                              .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 15,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                SizedBox(width: 10),
                                                IconButton(
                                                  onPressed: () {
                                                    Provider.of<CartProvider>(
                                                      context,
                                                      listen: false,
                                                    ).addRemove(
                                                      int.parse(menu.id),
                                                      true,
                                                    );
                                                    Provider.of<CartProvider>(
                                                      context,
                                                      listen: false,
                                                    ).printClickCount(
                                                      int.parse(menu.id),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.add_circle,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text("Tidak ada data"),
                      );
                    }
                  } else {
                    return Center(
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
