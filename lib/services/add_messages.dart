import 'package:analytics_app/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addMessage(name, message) async {
  final docUser = FirebaseFirestore.instance
      .collection('Messages')
      .doc(DateTime.now().toString());

  final json = {
    'name': name,
    'message': message,
    'id': docUser.id,
    'dateTime': DateTime.now(),
  };

  await docUser.set(json);
}
