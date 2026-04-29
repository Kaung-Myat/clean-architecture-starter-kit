class AuthRemoteSource {
  Future<Map<String, dynamic>> googleSignInAPI() async {
    await Future.delayed(const Duration(seconds: 1));
    return {"id": "g-123", "email": "dev@google.com", "type": "Google", "name": "Guest"};
  }

  Future<Map<String, dynamic>> emailSignInAPI(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (password == '123456') {
      return {"id": "e-456", "email": email, "type": "Traditional", "name": "Guest"};
    }
    throw Exception("Password မှားယွင်းနေပါသည်။");
  }
}
