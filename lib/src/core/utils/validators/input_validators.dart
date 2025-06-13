class InputValidator {
  /// Validates if the input is a valid email address.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email cannot be empty";
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value)) {
      return "Invalid email format";
    }
    return null;
  }

  /// Validates if the input is a valid password.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  /// Validates if the input is a valid phone number.
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number cannot be empty";
    }
    final phoneRegex = RegExp(r"^\+?[0-9]{10,11}$");
    if (!phoneRegex.hasMatch(value)) {
      return "Invalid phone number format";
    }
    return null;
  }

  /// Validates if the input is a valid fullname.
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your full name";
    }

    // Remove leading/trailing spaces for further checks
    final trimmed = value.trim();

    // Check minimum length (e.g., at least 4 characters)
    if (trimmed.length < 4) {
      return "Full name is too short";
    }

    // Check maximum length (e.g., max 50 characters)
    if (trimmed.length > 50) {
      return "Full name is too long";
    }

    // Regex for Vietnamese names: letters (including Vietnamese), spaces, hyphens, apostrophes, dots
    final RegExp nameRegExp = RegExp(
      r"^[a-zA-ZÀ-ỹà-ỹĂăÂâĐđÊêÔôƠơƯưÁáÀàẢảÃãẠạẮắẰằẲẳẴẵẶặẤấẦầẨẩẪẫẬậÉéÈèẺẻẼẽẸẹẾếỀềỂểỄễỆệÍíÌìỈỉĨĩỊịÓóÒòỎỏÕõỌọỐốỒồỔổỖỗỘộỚớỜờỞởỠỡỢợÚúÙùỦủŨũỤụỨứỪừỬửỮữỰựÝýỲỳỶỷỸỹỴỵ\s\-\'\.]+$",
    );

    if (!nameRegExp.hasMatch(trimmed)) {
      return "Full name contains invalid characters";
    }

    // Check for at least one space (first and last name)
    if (!trimmed.contains(" ")) {
      return "Please enter both first and last names";
    }

    // Check for consecutive spaces
    if (trimmed.contains("  ")) {
      return "Too many spaces between names";
    }

    return null; // Return null if valid
  }
}
