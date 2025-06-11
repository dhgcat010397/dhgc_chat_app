import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel extends Equatable {
  final String id;
  final DateTime createdAt;
  final String ownerId;
  final List<String> participants;
  final bool isOnline;
  final String lastMessage;
  final DateTime? lastMessageAt;

  const ConversationModel({
    required this.id,
    required this.createdAt,
    required this.ownerId,
    required this.participants,
    this.isOnline = true,
    required this.lastMessage,
    required this.lastMessageAt,
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    ownerId,
    participants,
    isOnline,
    lastMessage,
    lastMessageAt,
  ];

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      ownerId: json['ownerId'] as String,
      participants: List<String>.from(json['participants'] as List),
      isOnline: json['isOnline'] as bool? ?? true,
      lastMessage: json['lastMessage'] as String,
      lastMessageAt: (json['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'ownerId': ownerId,
      'participants': participants,
      'isOnline': isOnline,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageAt?.toIso8601String(),
    };
  }

  ConversationModel copyWith({
    String? id,
    DateTime? createdAt,
    String? ownerId,
    List<String>? participants,
    bool? isOnline,
    String? lastMessage,
    DateTime? lastMessageAt,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      ownerId: ownerId ?? this.ownerId,
      participants: participants ?? List<String>.from(this.participants),
      isOnline: isOnline ?? this.isOnline,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}
