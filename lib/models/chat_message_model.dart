import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError; // ADDED: To identify error messages

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false, // Default to false
  });

  // fromFirestore and toFirestore methods remain the same
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    return ChatMessage(
      text: data['text'] ?? '',
      isUser: data['sender'] == 'user',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'sender': isUser ? 'user' : 'ai',
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
