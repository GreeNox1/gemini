class ApiError implements Exception {
  const ApiError({required this.text});

  final String text;

  @override
  String toString() {
    return "Api error exception";
  }
}
