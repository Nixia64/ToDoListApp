String? stringNotEmptyValidator (value, message) {
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  return null;
}