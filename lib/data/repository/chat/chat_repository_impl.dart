import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../model/chat.dart';
import '../../model/message.dart';
import 'chat_repository.dart';




class ChatRepositoryImpl extends ChatRepository {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  @override
  Stream<List<Chat>> getAllChats() {
    return _db.child("chats").onValue.map((event) {
      final dynamic snapshotValue = event.snapshot.value;

      if (snapshotValue == null || snapshotValue is! Map<dynamic, dynamic>) {
        return []; // Return empty list if no data
      }

      // Convert the snapshot value to a properly typed map
      final Map<String, dynamic> data = Map<String, dynamic>.from(snapshotValue);

      return data.entries.map((entry) {
        final chatData = entry.value;

        if (chatData is Map) {
          try {
            // Ensure deep conversion of dynamic map values
            final parsedChatData = Map<String, dynamic>.from(
                chatData.map((key, value) => MapEntry(key.toString(), value))
            );

            return Chat.fromMap({...parsedChatData, "id": entry.key});
          } catch (e) {
            print("Error parsing chat data: $e");
          }
        }

        return null; // Skip invalid entries
      }).whereType<Chat>().toList();
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

  Future<Chat> createNewChat(String userId, String? customerName) async {
    String chatId = const Uuid().v4(); // Generate a unique chat ID

    Chat newChat = Chat(
      id: chatId,
      userId: userId,
      isClosed: false,
      createdAt: DateTime.now().toUtc(),
      messages: [],
      customerName: customerName,
    );

    await _db.child("chats").child(chatId).set(newChat.toMap());
    return newChat;
  }
}
