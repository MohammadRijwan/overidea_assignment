import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:overidea_assignment/src/feature/chat/data/chat_repo.dart';
import 'package:overidea_assignment/src/feature/chat/domain/interface/i_chat_repo.dart';

class ChatUseCase {
  late IChatRepo _chatRepository;

  ChatUseCase({IChatRepo? authRepository}) {
    _chatRepository = authRepository ?? GetIt.instance.get<ChatRepo>();
  }

  Future<void> sendMessage(String receiverId, String message) async {
    await _chatRepository.sendMessage(receiverId, message);
  }

  Stream<QuerySnapshot> fetchMessages(
      {required String userId, required String otherUserId}) {
    return _chatRepository.fetchMessages(
        userId: userId, otherUserId: otherUserId);
  }
}
