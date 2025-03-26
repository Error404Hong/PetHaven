import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/chat.dart';
import '../../data/repository/chat/chat_repository_impl.dart';

class SelectChat extends StatefulWidget {
  const SelectChat({super.key});

  @override
  State<SelectChat> createState() => _SelectChatState();
}

class _SelectChatState extends State<SelectChat> {
  final ChatRepositoryImpl _chatRepository = ChatRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromRGBO(172, 208, 193, 1),
        title: const Text("Select Chat", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: StreamBuilder<List<Chat>>(
        stream: _chatRepository.getAllChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final chats = snapshot.data ?? [];

          if (chats.isEmpty) {
            return Center(child: Text("No active chats available"));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                title: Text("Chat with ${chat.customerName}"),
                subtitle: Text("Created at: ${chat.createdAt}"),
                trailing: Icon(Icons.chat),
                onTap: () {
                  context.push(
                    "/customer_support",
                    extra: {
                      "chatId": chat.id,
                      "customerName": chat.customerName,
                      "isAdmin": true,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Placeholder ChatScreen (replace with actual chat UI)
class ChatScreen extends StatelessWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${chat.userId}")),
      body: Center(child: Text("Chat details go here")),
    );
  }
}
