import '../../model/chat.dart';
import '../../model/message.dart';

abstract class ChatRepository {
  Stream<List<Chat>> getAllChats();
  Stream<List<Message>> getMessages(String chatId);
  Future<void> sendMessage(String chatId, String userId, String text);
  Future<void> closeChat(String chatId);
  Future<void> createNewChat(String userId, String? customerName);
}