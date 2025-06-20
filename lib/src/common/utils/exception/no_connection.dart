class Connection implements Exception {
  const Connection({required this.text});

  final String text;

  @override
  String toString() {
    return "Connection exception";
  }
}
