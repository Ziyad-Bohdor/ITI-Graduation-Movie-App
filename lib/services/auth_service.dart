import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUp({
  required String email,
  required String password,
}) async {
  try {
    final credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      await addUserToFirestore(
        uid: credential.user!.uid,
        email: email,
      );
    }

    return credential.user;
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message ?? 'Registration failed');
  }
}

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> addUserToFirestore({
  required String uid,
  required String email,
}) async {
  await _firestore.collection('users').doc(uid).set({
    'uid': uid,
    'email': email,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

}