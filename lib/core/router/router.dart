import 'package:bolt/core/router/routes.dart';
import 'package:bolt/features/auth/presentation/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    routes: $appRoutes,
    redirect: (context, state) {
      // If we are still initializing auth, do nothing (or show splash)
      if (authState.isLoading || authState.hasError) return null;

      final value = authState.asData?.value;
      if (value == null) return null; // Still loading or initial

      // TODO: Use 'is AuthStateAuthenticated' or 'map' once static analysis visibility issue is resolved.
      print('Router Redirect: Checking path ${state.uri.path}');

      final type = value.runtimeType.toString();
      final isAuthenticated = type == 'AuthStateAuthenticated';

      final isLoginRoute = state.uri.path == '/login';
      final isCallbackRoute = state.uri.path.startsWith('/callback');

      print(
        'Router Redirect: isAuthenticated=$isAuthenticated, isLoginRoute=$isLoginRoute, isCallbackRoute=$isCallbackRoute',
      );

      if (!isAuthenticated) {
        // Allow access to matching route for deep linking setup (if needed) but generally force login
        // If we are on callback route but NOT authenticated yet, we should let it process?
        // Actually, if we are not authenticated, we might be IN THE PROCESS of authenticating on /callback.
        // So we should allow /callback to run.
        if (isCallbackRoute) return null;
        return isLoginRoute ? null : '/login';
      }

      if (isAuthenticated && (isLoginRoute || isCallbackRoute)) {
        return '/';
      }

      return null;
    },
  );
}
