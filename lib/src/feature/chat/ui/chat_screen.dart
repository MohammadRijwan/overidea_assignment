import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overidea_assignment/src/core/utils/app_constant.dart';
import 'package:overidea_assignment/src/feature/auth/domain/model/user.dart';
import 'package:overidea_assignment/src/feature/chat/domain/model/message.dart';
import 'package:overidea_assignment/src/feature/chat/domain/usecase/chat_usecase.dart';

class ChatScreen extends StatelessWidget {
  static String route = 'chat_screen';
  final UserModel receiverUser;

  const ChatScreen({super.key, required this.receiverUser});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${receiverUser.name}'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * (AppConstant.isWeb ? 0.2 : 0),
            vertical: 15.0),
        child: Container(
          decoration: AppConstant.isWeb
              ? BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(child: MessageList(userId: receiverUser.userId)),
                MessageInput(
                  userId: receiverUser.userId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageItem extends StatefulWidget {
  final DocumentSnapshot document;
  const MessageItem({super.key, required this.document});

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  bool isSender = false;
  Message? message;
  @override
  void initState() {
    message = Message.fromMap(widget.document.data() as Map<String, dynamic>);
    isSender = message!.senderId == FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message?.senderEmail ?? ''),
            Container(
                decoration: BoxDecoration(
                  color:
                      isSender ? Theme.of(context).primaryColor : Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message?.message ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
            Text(
              '${message?.timestamp.toDate().hour}:${message?.timestamp.toDate().minute}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  final String userId;
  const MessageList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatUseCase().fetchMessages(
          userId: userId, otherUserId: FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs
              .map((doc) => MessageItem(document: doc))
              .toList(),
        );
      },
    );
  }
}

class MessageInput extends StatefulWidget {
  final String userId;
  const MessageInput({super.key, required this.userId});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _messageController,
        decoration: InputDecoration(
            hintText: 'Enter message',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: () {
                ChatUseCase()
                    .sendMessage(widget.userId, _messageController.text);
                _messageController.clear();
              },
              icon: const Icon(Icons.send),
            )),
      ),
    );
  }
}
