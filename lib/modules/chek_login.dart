import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yukopiapps/view/home_page.dart';
import 'package:yukopiapps/view/login_view.dart';

class CheckLoginPage extends StatelessWidget {
  const CheckLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // Pengguna sudah login, arahkan ke halaman utama
          return const HomePage();
        } else {
          // Pengguna belum login, arahkan ke halaman login
          return LoginPages();
        }
      },
    );
  }
}
