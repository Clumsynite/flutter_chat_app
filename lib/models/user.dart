import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String username;
  final String email;
  String? firstname;
  String? lastName;
  String? avatar;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstname,
    this.lastName,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'firstname': firstname,
      'lastName': lastName,
      'avatar': avatar,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      firstname: map['firstname'] != null ? map['firstname'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? firstname,
    String? lastName,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
    );
  }
}
