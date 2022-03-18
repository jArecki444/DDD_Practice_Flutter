import 'package:auto_route/auto_route.dart';
import 'package:ddd_practice_flutter/presentation/notes/notes_overview/notes_overview_page.dart';
import 'package:ddd_practice_flutter/presentation/sign_in/sign_in_page.dart';
import 'package:ddd_practice_flutter/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: SignInPage),
    AutoRoute(page: NotesOverviewPage),
  ],
)
class AppRouter extends _$AppRouter {}
