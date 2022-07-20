import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Contact {
  final String id;
  final String username;
  final String email;
  final bool isFriend;
  final bool isOnline;
  String? firstName;
  String? lastName;
  String? avatar;
  bool? isRequested; // friend request sent this contact?

  Contact({
    required this.id,
    required this.username,
    required this.email,
    required this.isFriend,
    required this.isOnline,
    this.firstName,
    this.lastName,
    this.avatar,
    this.isRequested,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'isFriend': isFriend,
      'isOnline': isOnline,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'isRequested': isRequested,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['_id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      isFriend: map['isFriend'] as bool,
      isOnline: map['isOnline'] as bool,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      isRequested:
          map['isRequested'] != null ? map['isRequested'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source) as Map<String, dynamic>);

  Contact copyWith({
    String? id,
    String? username,
    String? email,
    bool? isFriend,
    bool? isOnline,
    String? firstName,
    String? lastName,
    String? avatar,
    bool? isRequested,
  }) {
    return Contact(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      isFriend: isFriend ?? this.isFriend,
      isOnline: isOnline ?? this.isOnline,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      isRequested: isRequested ?? this.isRequested,
    );
  }
}
