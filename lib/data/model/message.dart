class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "senderId": senderId,
      "text": text,
      "timestamp": timestamp.toIso8601String(),
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      id: map["id"],
      senderId: map["senderId"],
      text: map["text"],
      timestamp: DateTime.parse(map["timestamp"]),
    );
  }
}
