import 'message.dart';

class Chat {
  final String id;
  final String userId;
  final DateTime createdAt;
  final bool isClosed;
  final List<Message> messages;
  final String? customerName;

  Chat({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.isClosed,
    required this.messages,
    this.customerName
  });

  Chat copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    bool? isClosed,
    List<Message>? messages,
    String? customerName,
  }) {
    return Chat(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      isClosed: isClosed ?? this.isClosed,
      messages: messages ?? this.messages,
      customerName: customerName ?? this.customerName
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "customerName": customerName,
      "createdAt": createdAt.toIso8601String(),
      "isClosed": isClosed,
      "messages": messages.map((msg) => msg.toMap()).toList(),
      "customerName": customerName
    };
  }
  static Chat fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map["id"] ?? "",
      userId: map["userId"] ?? "",
      createdAt: DateTime.tryParse(map["createdAt"] ?? "") ?? DateTime.now(),
      isClosed: map["isClosed"] ?? false,
      customerName: map["customerName"] ?? "Unknown", // Default value to avoid null issues
      messages: (map["messages"] is Map) // Ensure messages is a Map
          ? (map["messages"] as Map).entries.map((entry) {
        final msgData = entry.value;
        if (msgData is Map) {
          return Message.fromMap({...Map<String, dynamic>.from(msgData), "id": entry.key});
        }
        return null; // Skip invalid message entries
      }).whereType<Message>().toList()
          : [],
    );
  }


}
