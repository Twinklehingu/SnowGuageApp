class AuthService {
  Future<bool> login(String email, String password) async {
    // Replace this with our actual authentication logic
    // we might call an API or use a library like Firebase for authentication
    //
    if (email == 'user@example.com' && password == 'password') {
      return true; // Successful login
    } else {
      return false; // Invalid credentials
    }
  }
}
