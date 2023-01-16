import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseService {
  static final firestore = FirebaseFirestore.instance;
  static CollectionReference personRef = firestore.collection("Person");
}
