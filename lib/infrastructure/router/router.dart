import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_flutter_go_router/infrastructure/router/routes.dart';
import 'package:study_flutter_go_router/login_state.dart';
import 'package:study_flutter_go_router/presentation/create_account.dart';
import 'package:study_flutter_go_router/presentation/error_page.dart';
import 'package:study_flutter_go_router/presentation/login.dart';

class AppRouter {
  final LoginState loginState;

  AppRouter({required this.loginState});

  late final router = GoRouter(
    refreshListenable: loginState,
    // TODO remove when app is finished
    debugLogDiagnostics: kDebugMode,
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        name: Routes.root,
        path: '/',
        redirect: (state) =>
            // TODO: Change to Home Route
            state.namedLocation(Routes.login),
      ),
      GoRoute(
        name: Routes.login,
        path: '/login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const Login(),
        ),
      ),
      GoRoute(
        name: Routes.createAccount,
        path: '/create-account',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const CreateAccount(),
        ),
      ),
      // TODO: Add Home route and children
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),

    // TODO Add Redirect
  );
}
