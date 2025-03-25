import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../model/chat.dart';
import '../../model/message.dart';
import 'chat_repository.dart';




class ChatRepositoryImpl extends ChatRepository {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  @override
  Stream<List<Chat>> getActiveChats() {
    return _db.child("chats").orderByChild("isClosed").equalTo(false).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      return data.entries.map((entry) {
        return Chat.fromMap({...entry.value, "id": entry.key});
      }).toList();
    });
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    return _db.child("chats").child(chatId).child("messages").onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      return data.entries.map((entry) {
        return Message.fromMap({...entry.value, "id": entry.key});
      }).toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Sort messages by timestamp
    });
  }

  @override
  Future<void> sendMessage(String chatId, String userId, String text) async {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: userId,
      text: text,
      timestamp: DateTime.now().toUtc(),
    );
    await _db.child("chats").child(chatId).child("messages").push().set(message.toMap());
  }

  @override
  Future<void> closeChat(String chatId) async {
    await _db.child("chats").child(chatId).update({"isClosed": true});
  }

  Future<Chat> createNewChat(String userId) async {
    String chatId = const Uuid().v4(); // Generate a unique chat ID

    Chat newChat = Chat(
      id: chatId,
      userId: userId,
      isClosed: false,
      createdAt: DateTime.now().toUtc(),
      messages: [],
    );

    await _db.child("chats").child(chatId).set(newChat.toMap());
    return newChat;
  }
}
