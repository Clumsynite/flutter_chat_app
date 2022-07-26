import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String from;
  final String to;
  final String text;
  final bool unread;

  Message({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.from,
    required this.to,
    required this.text,
    required this.unread,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'from': from,
      'to': to,
      'text': text,
      'unread': unread,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['_id'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      from: map['from'] as String,
      to: map['to'] as String,
      text: map['text'] as String,
      unread: map['unread'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  Message copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? from,
    String? to,
    String? text,
    bool? unread,
  }) {
    return Message(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      from: from ?? this.from,
      to: to ?? this.to,
      text: text ?? this.text,
      unread: unread ?? this.unread,
    );
  }
}
