import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //giriş yap fonksiyonu
  Future<User?> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  //çıkış yap fonksiyonu
  signOut() async {
    return await _auth.signOut();
  }

  //kayıt ol fonksiyonu
  Future<User?> createPerson(
      {required String name,
      required String email,
      required String password,
      required String mezunbolum,
      required String calismadurum,
      required String hakkinda,
      required String il,
      required String alan}) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestore.collection("Person").doc(user.user!.uid).set({
      'userName': name,
      'email': email,
      "mezunbolum": mezunbolum,
      "calismadurum": calismadurum,
      "hakkinda": hakkinda,
      "il": il,
      "alan": alan,
      "onay": false,
    });

    return user.user;
  }
}
