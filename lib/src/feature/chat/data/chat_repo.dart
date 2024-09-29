import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overidea_assignment/src/core/data/remote/firebase_db.dart';
import 'package:overidea_assignment/src/core/domain/datasource/i_db.dart';
import 'package:overidea_assignment/src/feature/chat/domain/interface/i_chat_repo.dart';
import 'package:overidea_assignment/src/feature/chat/domain/model/message.dart';

class ChatRepo extends IChatRepo {
  late IDb _database;
  late FirebaseAuth _firebaseAuth;
  ChatRepo({IDb? database}) {
    _firebaseAuth = FirebaseAuth.instance;
    _database = database ?? FirebaseDb();
  }

  @override
  Stream<QuerySnapshot> fetchMessages(
      {required String userId, required String otherUserId}) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _database.fetchMessages(chatRoomId: chatRoomId);
  }

  @override
  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _database.sendMessage(chatRoomId: chatRoomId, message: newMessage);

    final messaging = FirebaseMessaging.instance;
    await messaging.sendMessage(to: 'recipient_token', data: {
      'key1': 'value1',
      'message': 'value2',
    });
  }
}
