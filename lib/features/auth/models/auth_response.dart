class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserData user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // json IS already the full response
    // so we need to get 'data' first
    final data = json['data'] as Map<String, dynamic>;
    final userMap = data['user'] as Map<String, dynamic>;

    return AuthResponse(
      accessToken: data['access_token'] ?? '',
      refreshToken: data['refresh_token'] ?? '',
      user: UserData.fromJson(userMap),
    );
  }
}

class UserData {
  final int userId;
  final String username;
  final String role;

  UserData({
    required this.userId,
    required this.username,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'] as int,
      username: json['username'] ?? '',
      role: json['role'] ?? '',
    );
  }
}