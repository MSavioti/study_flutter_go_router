import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_flutter_go_router/infrastructure/router/routes.dart';
import 'package:study_flutter_go_router/login_state.dart';
import 'package:study_flutter_go_router/presentation/create_account.dart';
import 'package:study_flutter_go_router/presentation/details.dart';
import 'package:study_flutter_go_router/presentation/error_page.dart';
import 'package:study_flutter_go_router/presentation/home_screen.dart';
import 'package:study_flutter_go_router/presentation/login.dart';
import 'package:study_flutter_go_router/presentation/more_info.dart';
import 'package:study_flutter_go_router/presentation/payment.dart';
import 'package:study_flutter_go_router/presentation/personal_info.dart';
import 'package:study_flutter_go_router/presentation/signin_info.dart';

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
        redirect: (state) => state.namedLocation(
          Routes.home,
          params: {'tab': 'shop'},
        ),
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
      GoRoute(
        name: Routes.home,
        path: '/home/:tab(shop|cart|profile)',
        pageBuilder: (context, state) {
          final tab = state.params['tab']!;
          return MaterialPage<void>(
            key: state.pageKey,
            child: HomeScreen(tab: tab),
          );
        },
        routes: [
          GoRoute(
            name: Routes.subDetails,
            path: 'details/:item',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: Details(description: state.params['item']!),
            ),
          ),
          GoRoute(
            name: Routes.profilePersonal,
            path: 'personal',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const PersonalInfo(),
            ),
          ),
          GoRoute(
            name: Routes.profilePayment,
            path: 'payment',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const Payment(),
            ),
          ),
          GoRoute(
            name: Routes.profileSigninInfo,
            path: 'signin-info',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const SigninInfo(),
            ),
          ),
          GoRoute(
            name: Routes.profileMoreInfo,
            path: 'more-info',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const MoreInfo(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/shop',
        redirect: (state) =>
            state.namedLocation(Routes.home, params: {'tab': 'shop'}),
      ),
      GoRoute(
        path: '/cart',
        redirect: (state) =>
            state.namedLocation(Routes.home, params: {'tab': 'cart'}),
      ),
      GoRoute(
        path: '/profile',
        redirect: (state) =>
            state.namedLocation(Routes.home, params: {'tab': 'profile'}),
      ),
      GoRoute(
        name: Routes.details,
        path: '/details-redirector/:item',
        redirect: (state) => state.namedLocation(
          Routes.subDetails,
          params: {'tab': 'shop', 'item': state.params['item']!},
        ),
      ),
      GoRoute(
        name: Routes.personal,
        path: '/profile-personal',
        redirect: (state) => state.namedLocation(
          Routes.profilePersonal,
          params: {'tab': 'profile'},
        ),
      ),
      GoRoute(
        name: Routes.payment,
        path: '/profile-payment',
        redirect: (state) => state.namedLocation(
          Routes.profilePayment,
          params: {'tab': 'profile'},
        ),
      ),
      GoRoute(
        name: Routes.signinInfo,
        path: '/profile-signin-info',
        redirect: (state) => state.namedLocation(
          Routes.profileSigninInfo,
          params: {'tab': 'profile'},
        ),
      ),
      GoRoute(
        name: Routes.moreInfo,
        path: '/profile-more-info',
        redirect: (state) => state.namedLocation(
          Routes.profileMoreInfo,
          params: {'tab': 'profile'},
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),

    redirect: (state) {
      final loginLocation = state.namedLocation(Routes.login);
      final isLoggingIn = state.subloc == loginLocation;
      final createAccountLocation = state.namedLocation(Routes.createAccount);
      final isCreatingAccount = state.subloc == createAccountLocation;
      final isLoggedIn = loginState.loggedIn;
      final rootLoc = state.namedLocation(Routes.root);

      if (!isLoggedIn && !isLoggingIn && !isCreatingAccount) {
        return loginLocation;
      }

      if (isLoggedIn && (isLoggingIn || isCreatingAccount)) {
        return rootLoc;
      }

      return null;
    },
  );
}
