import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:yukopiapps/admin/view/addmenu_page_view.dart';
import 'package:yukopiapps/admin/view/list_menu_view.dart';
import 'package:yukopiapps/controller/cart_provider.dart';
import 'package:yukopiapps/modules/chek_out_screen.dart';
import 'package:yukopiapps/modules/order_list_model.dart';

import 'package:yukopiapps/user/view/menu_page_view.dart';
import 'package:yukopiapps/view/DetailMenu.dart';
import 'package:yukopiapps/view/provil_view.dart';
import 'package:badges/badges.dart' as badges;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> _pagesAdmin = [
    AddMenuPage(),
    ViewListMenuPage(),
    OrderListPage(
      name: '',
      option: CheckoutOption.takeHome,
      paymentMethod: '',
      orderItems: [],
    ),
    ProfilViewPage(),
  ];

  List<Widget> _pagesUser = [
    MenuPageUser(),
    DetailMenu(),
    ProfilViewPage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = _pagesAdmin;

    // Periksa peran pengguna dan tentukan halaman yang sesuai
    // berdasarkan peran (admin atau pengguna biasa)
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email == '2006008@itg.ac.id') {
      _pages = _pagesAdmin;
    } else {
      _pages = _pagesUser;
    }

    List<TabItem> _tabItems = [
      TabItem(icon: Icons.input, title: 'Input'),
      TabItem(icon: Icons.list, title: 'List'),
      TabItem(icon: Icons.menu_book_outlined, title: 'View Detail'),
      TabItem(icon: Icons.person, title: 'Profile'),
    ];

    // Periksa peran pengguna dan tentukan item tab yang sesuai
    // berdasarkan peran (admin atau pengguna biasa)
    if (currentUser != null && currentUser.email != '2006008@itg.ac.id') {
      _tabItems = [
        TabItem(icon: Icons.coffee_outlined, title: 'Menu'),
        TabItem(icon: Icons.menu_book_outlined, title: 'Detail Menu'),
        TabItem(icon: Icons.person, title: 'Profile'),
      ];
    }

    Widget appBarUser = AppBar(
      backgroundColor: Colors.brown,
      title: Text("Yukopi Apps"),
      actions: [
        Consumer<CartProvider>(
          builder: (context, value, _) {
            return badges.Badge(
              badgeAnimation: const badges.BadgeAnimation.rotation(),
              position: badges.BadgePosition.topStart(top: -2, start: 1),
              badgeContent: Text(
                (value.total > 0) ? value.total.toString() : "",
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_basket_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Navigate to CheckoutPage with argument
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        cartProvider: value,
                        orderList: [],
                      ), // Pass the cartProvider as an argument
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );

    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: Scaffold(
        appBar:
            (currentUser != null && currentUser.email != '2006008@itg.ac.id')
                ? PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: appBarUser,
                  )
                : AppBar(
                    title: Text('Yukopi Apps'),
                  ),
        body: _pages[_currentIndex],
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.brown,
          style: TabStyle.reactCircle,
          items: _tabItems,
          initialActiveIndex: _currentIndex,
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}
