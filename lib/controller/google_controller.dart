import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user?.email == '2006008@itg.ac.id') {
        // Pengguna dengan email "2006008@itg.ac.id" adalah admin
        print('Admin logged in');
      } else {
        // Pengguna selain admin
        print('User logged in');
      }

      return userCredential;
    } catch (error) {
      print("Error signing in with Google: $error");
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      print("Google user signed out");
    } catch (error) {
      print("Error signing out from Google: $error");
    }
  }
}
