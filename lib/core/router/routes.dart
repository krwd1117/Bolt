import 'package:bolt/features/auth/presentation/login_screen.dart';
import 'package:bolt/features/memo/presentation/memo_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

// FORCE REBUILD 1

@TypedGoRoute<MemoRoute>(path: '/')
class MemoRoute extends GoRouteData with $MemoRoute {
  const MemoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const MemoScreen();
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedGoRoute<CallbackRoute>(path: '/callback')
class CallbackRoute extends GoRouteData with $CallbackRoute {
  const CallbackRoute({this.code});

  final String? code;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    print('CallbackRoute built. URI: ${state.uri}');
    print('CallbackRoute params: ${state.uri.queryParameters}');
    if (code != null) {
      return LoginScreen(authCode: code);
    }
    return const LoginScreen();
  }
}
