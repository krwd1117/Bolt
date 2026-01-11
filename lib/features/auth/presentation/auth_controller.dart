import 'package:bolt/features/auth/data/auth_repository.dart';
import 'package:bolt/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<AuthState> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final token = await repo.getAccessToken();
    if (token != null) {
      return AuthState.authenticated(token);
    }
    return const AuthState.unauthenticated();
  }

  Future<void> launchAuthFlow() async {
    // final repo = ref.read(authRepositoryProvider);
    // final url = repo.getAuthorizationUrl(); // Unused
    // Use url_launcher to open this URL
    // We can't directly call launchUrl here as it requires a UI context or platform channel,
    // although url_launcher works from logic if configured.
    // Ideally this should be returned to the UI or handled via a side-effect.
    // For simplicity, we will return the URL or launch it if possible,
    // but better practice is to expose the URL or have UI trigger it.
    // Let's assume the UI calls a separate method to get URL or we use a provider for the action.
    // Actually, let's just expose the URL getter or handle it in the UI based on a state,
    // or just let the UI call repo directly for the URL.
    // To keep it clean, let's add a method here that validates pre-reqs if any.
  }

  Future<void> login(String authCode) async {
    // Optimistic loading
    state = const AsyncValue.data(AuthState.loading());

    state = await AsyncValue.guard(() async {
      print('AuthController: Exchanging code code for token...');
      final repo = ref.read(authRepositoryProvider);
      final token = await repo.exchangeCodeForToken(authCode);
      print('AuthController: Token received: $token');
      await repo.saveAccessToken(token);
      print('AuthController: Token saved. Authenticated.');
      return AuthState.authenticated(token);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.data(AuthState.loading());

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.deleteAccessToken();
      return const AuthState.unauthenticated();
    });
  }
}
