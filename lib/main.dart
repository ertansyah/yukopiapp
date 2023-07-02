import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yukopiapps/controller/cart_provider.dart';
import 'package:yukopiapps/modules/check_introduction_page.dart';
import 'package:yukopiapps/view/splash_screen_view.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => const CheckIntroductionPage(),
      },
    );
  }
}
