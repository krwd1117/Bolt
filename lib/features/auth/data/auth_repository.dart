import 'dart:convert';
import 'package:bolt/core/network/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bolt/env/env.dart';

// part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<String?> getAccessToken();
  Future<void> saveAccessToken(String token);
  Future<void> deleteAccessToken();
  Future<String> exchangeCodeForToken(String authCode);
  Uri getAuthorizationUrl();
}

class AuthRepositoryImpl implements AuthRepository {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  AuthRepositoryImpl(this._storage, this._dio);

  static const _tokenKey = 'notion_access_token';

  @override
  Future<String?> getAccessToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<void> deleteAccessToken() => _storage.delete(key: _tokenKey);

  @override
  Future<String> exchangeCodeForToken(String authCode) async {
    try {
      final basicAuth =
          'Basic ${base64Encode(utf8.encode('${Env.notionClientId}:${Env.notionClientSecret}'))}';

      final response = await _dio.post(
        '/oauth/token',
        options: Options(
          headers: {
            'Authorization': basicAuth,
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'grant_type': 'authorization_code',
          'code': authCode,
          'redirect_uri': Env.notionRedirectUri,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['access_token'] as String;
        // Optionally store other details like workspace_id, bot_id, etc.
        return accessToken;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to exchange token',
        );
      }
    } catch (e) {
      // Re-throw or handle error
      throw Exception('Failed to authentication with Notion: $e');
    }
  }

  @override
  Uri getAuthorizationUrl() {
    return Uri.https('api.notion.com', '/v1/oauth/authorize', {
      'client_id': Env.notionClientId,
      'response_type': 'code',
      'owner': 'user',
      'redirect_uri': Env.notionRedirectUri,
    });
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepositoryImpl(const FlutterSecureStorage(), dio);
});
