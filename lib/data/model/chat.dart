import 'message.dart';

class Chat {
  final String id;
  final String userId;
  final DateTime createdAt;
  final bool isClosed;
  final List<Message> messages;

  Chat({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.isClosed,
    required this.messages,
  });

  Chat copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    bool? isClosed,
    List<Message>? messages,
  }) {
    return Chat(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      isClosed: isClosed ?? this.isClosed,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "createdAt": createdAt.toIso8601String(),
      "isClosed": isClosed,
      "messages": messages.map((msg) => msg.toMap()).toList(),
    };
  }

  static Chat fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map["id"],
      userId: map["userId"],
      createdAt: DateTime.parse(map["createdAt"]),
      isClosed: map["isClosed"],
      messages: (map["messages"] as List<dynamic>)
          .map((msg) => Message.fromMap(msg))
          .toList(),
    );
  }
}
