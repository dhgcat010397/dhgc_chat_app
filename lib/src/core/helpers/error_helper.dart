import 'package:dhgc_chat_app/src/core/utils/extensions/string_extension.dart';

class ErrorHelper {
  static String showFirebaseError(String code, String action) {
    switch (code) {
      case 'permission-denied':
        return 'You don\'t have permission to $action';
      case 'not-found':
        return 'Document not found';
      case 'aborted':
        return '${action.capitalize()} was cancelled';
      case 'unavailable':
        return 'Network unavailable. Please check connection';
      default:
        return 'Failed to $action (code: $code)';
    }
  }

  static Exception showAuthError(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return Exception('Account already exists with different method');
      case 'invalid-credential':
        return Exception('Invalid authentication credentials');
      case 'operation-not-allowed':
        return Exception('Google sign-in is not enabled');
      case 'user-disabled':
        return Exception('This account has been disabled');
      case 'user-not-found':
        return Exception('No account found for this email');
      case 'wrong-password':
        return Exception('Incorrect credentials');
      case 'network-request-failed':
        return Exception('Network error. Please check your connection');
      default:
        return Exception('Authentication failed (Code: $code)');
    }
  }
}
