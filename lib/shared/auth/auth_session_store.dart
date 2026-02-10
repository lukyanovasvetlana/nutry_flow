/// In-memory store for the latest auth credentials used in the session.
/// Note: This is for demo UI only and should not be used for production.
class AuthSessionStore {
  static String? lastEmail;
  static String? lastPassword;

  static void update({
    required String email,
    required String password,
  }) {
    lastEmail = email;
    lastPassword = password;
  }
}
