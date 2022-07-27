import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Friend {
  final String id;
  final String username;
  final String email;
  String? firstName;
  String? lastName;
  String? avatar;
  final bool isOnline;
  String? lastSeen;
  final String createdAt;
  final bool isTyping;
  final int unreadCount;

  Friend({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    required this.isOnline,
    this.lastSeen,
    required this.createdAt,
    required this.isTyping,
    required this.unreadCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'isTyping': isTyping,
      'unreadCount': unreadCount,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['_id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      isOnline: map['isOnline'] as bool,
      lastSeen: map['lastSeen'] != null ? map['lastSeen'] as String : null,
      createdAt: map['createdAt'] as String,
      isTyping: map['isTyping'] ?? false,
      unreadCount: map['unreadCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Friend.fromJson(String source) =>
      Friend.fromMap(json.decode(source) as Map<String, dynamic>);

  Friend copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
    bool? isOnline,
    String? lastSeen,
    String? createdAt,
    bool? isTyping,
    int? unreadCount,
  }) {
    return Friend(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      isTyping: isTyping ?? this.isTyping,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
