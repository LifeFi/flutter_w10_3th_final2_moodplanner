import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get user => _firebaseAuth.currentUser;
  bool get isLoggedIn => user != null;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<UserCredential> emailSignUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> emailSignIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? account = kIsWeb
        ? await googleSignIn.signInSilently()
        : await googleSignIn.signIn();
    if (kIsWeb && account == null) account = await googleSignIn.signIn();

    if (account != null) {
      // Obtain the auth details from the request
      GoogleSignInAuthentication authentication = await account.authentication;

      // Create a new credential
      OAuthCredential googleCredential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );
      // Once signed in, return the UserCredential
      UserCredential credential =
          await _firebaseAuth.signInWithCredential(googleCredential);

      if (credential.user != null) {
        return credential;
      }
    }
    return null;
  }

  Future<void> signOut() async {
    final isGoogleSignIn = await GoogleSignIn().isSignedIn();
    print("isGoogleSignIn: $isGoogleSignIn");
    if (isGoogleSignIn) await GoogleSignIn().signOut();
    print("isGoogleSignIn: $isGoogleSignIn");
    await _firebaseAuth.signOut();
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());

final authState = StreamProvider((ref) {
  final repo = ref.read(authRepo);
  return repo.authStateChanges();
});
