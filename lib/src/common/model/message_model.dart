class MessageModel {
  MessageModel({required this.role, required this.text});

  String role;
  String text;

  factory MessageModel.fromJson(Map<String, Object?> json) {
    return MessageModel(
      role: json["role"] as String,
      text: json["text"] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {"role": role, "text": text};
  }

  @override
  int get hashCode => Object.hash(role, text);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MessageModel &&
            other.runtimeType == runtimeType &&
            other.text == text &&
            other.role == role;
  }

  @override
  String toString() {
    return "MessageModel(role: $role: text: $text)";
  }
}
