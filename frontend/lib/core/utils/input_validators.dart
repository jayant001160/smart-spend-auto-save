class InputValidators {
  InputValidators._();

  static String? requiredText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? positiveNumber(String? value, String fieldName) {
    final String? requiredError = requiredText(value, fieldName);
    if (requiredError != null) {
      return requiredError;
    }

    final double? parsed = double.tryParse(value!.trim());
    if (parsed == null || parsed <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }
}
