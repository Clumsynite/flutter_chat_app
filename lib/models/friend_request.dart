import 'dart:convert';

import 'package:flutter_chat_app/models/contact.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FriendRequest {
  final String id;
  final String from;
  final String to;
  final String createdAt;
  final String updatedAt;
  final Contact contact;

  FriendRequest({
    required this.id,
    required this.from,
    required this.to,
    required this.createdAt,
    required this.updatedAt,
    required this.contact,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'from': from,
      'to': to,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'contact': contact.toMap(),
    };
  }

  factory FriendRequest.fromMap(Map<String, dynamic> map) {
    return FriendRequest(
      id: map['_id'] as String,
      from: map['from'] as String,
      to: map['to'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      contact: Contact.fromMap(map['contact'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendRequest.fromJson(String source) =>
      FriendRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  FriendRequest copyWith({
    String? id,
    String? from,
    String? to,
    String? createdAt,
    String? updatedAt,
    Contact? contact,
  }) {
    return FriendRequest(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contact: contact ?? this.contact,
    );
  }
}
