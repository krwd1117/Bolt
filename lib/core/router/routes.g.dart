// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$memoRoute, $loginRoute, $callbackRoute];

RouteBase get $memoRoute =>
    GoRouteData.$route(path: '/', factory: $MemoRoute._fromState);

mixin $MemoRoute on GoRouteData {
  static MemoRoute _fromState(GoRouterState state) => const MemoRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute =>
    GoRouteData.$route(path: '/login', factory: $LoginRoute._fromState);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $callbackRoute =>
    GoRouteData.$route(path: '/callback', factory: $CallbackRoute._fromState);

mixin $CallbackRoute on GoRouteData {
  static CallbackRoute _fromState(GoRouterState state) =>
      CallbackRoute(code: state.uri.queryParameters['code']);

  CallbackRoute get _self => this as CallbackRoute;

  @override
  String get location => GoRouteData.$location(
    '/callback',
    queryParams: {if (_self.code != null) 'code': _self.code},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
