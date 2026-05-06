import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/auth/models/auth_response.dart';

void main() {
  group('AuthResponse.fromJson', () {
    test('parses login response returned by the NestJS backend', () {
      final response = AuthResponse.fromJson({
        'success': true,
        'statusCode': 200,
        'message': 'Login successful',
        'data': {
          'access_token': 'access-token',
          'refresh_token': 'refresh-token',
          'user': {
            'user_ID': '8d7e3c6a',
            'username': 'kent',
            'role': 'buyer',
            'bankAccount': {
              'account_number': 123456789,
              'balance': 100,
            },
          },
          'timestamp': '2026-05-05T10:30:45.034Z',
        },
      });

      expect(response.accessToken, 'access-token');
      expect(response.refreshToken, 'refresh-token');
      expect(response.user.userId, '8d7e3c6a');
      expect(response.user.username, 'kent');
      expect(response.user.role, 'buyer');
    });
  });
}
