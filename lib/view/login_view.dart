import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yukopiapps/controller/google_controller.dart';
import 'package:yukopiapps/view/home_page.dart';

class LoginPages extends StatefulWidget {
  LoginPages({Key? key}) : super(key: key);

  @override
  _LoginPagesState createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final GoogleSignInController _googleSignInController =
      GoogleSignInController();
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/login_page.jpg",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Positioned(
              top: 40,
              child: Text(
                "Yukopi",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 10,
              right: 10,
              child: Card(
                color: Colors.black.withOpacity(0.3),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Pesan Kopi terbaikmu!",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 8,
                      ),
                      child: Text(
                        "Untuk menikmati semua fitur kami, Anda perlu terhubung terlebih dahulu",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isButtonPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isButtonPressed = false;
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _isButtonPressed = false;
                        });
                      },
                      onTap: () async {
                        final userCredential =
                            await _googleSignInController.signInWithGoogle();
                        if (userCredential != null) {
                          // Login berhasil, navigasi ke halaman home
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        } else {
                          // Login gagal, tampilkan pesan error atau
                          // lakukan tindakan yang diperlukan.
                          print('Login gagal!');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 32,
                        ),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          height: 56,
                          decoration: BoxDecoration(
                            color:
                                _isButtonPressed ? Colors.grey : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/google.png",
                                  width: 30,
                                ),
                                SizedBox(width: 30),
                                Text(
                                  "Login Sekarang",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
