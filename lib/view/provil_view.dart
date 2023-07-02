import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yukopiapps/controller/google_controller.dart';

class ProfilViewPage extends StatefulWidget {
  const ProfilViewPage({Key? key}) : super(key: key);

  @override
  _ProfilViewPageState createState() => _ProfilViewPageState();
}

class _ProfilViewPageState extends State<ProfilViewPage> {
  final GoogleSignInController _googleSignInController =
      GoogleSignInController();
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _signOut() async {
    await _googleSignInController.signOutGoogle();
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(
      context,
      '/login',
    ); // Kembali ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: _currentUser?.photoURL != null
                    ? NetworkImage(_currentUser!.photoURL!)
                    : null,
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 16.0),
              Text(
                _currentUser?.displayName ?? '',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _currentUser?.email ?? '',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton.icon(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 2.0,
                ),
                icon: Icon(Icons.logout),
                label: Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
