import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String username;
  final String email;
  final String token;
  final String password;
  String? firstName;
  String? lastName;
  String? avatar;
  final List<String> friends;
  final bool isOnline;
  String? lastSeen;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.password,
    this.firstName,
    this.lastName,
    this.avatar,
    required this.friends,
    required this.isOnline,
    this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'token': token,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'friends': friends,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
      password: map['password'] as String,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      friends: List<String>.from((map['friends'])),
      isOnline: map['isOnline'] as bool,
      lastSeen: map['lastSeen'] != null ? map['lastSeen'] as String : null,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? token,
    String? password,
    String? firstName,
    String? lastName,
    String? avatar,
    List<String>? friends,
    bool? isOnline,
    String? lastSeen,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      friends: friends ?? this.friends,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
