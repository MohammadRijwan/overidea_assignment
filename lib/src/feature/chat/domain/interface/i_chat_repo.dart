import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IChatRepo {
  Future<void> sendMessage(String receiverId, String message);
  Stream<QuerySnapshot> fetchMessages(
      {required String userId, required String otherUserId});
}
