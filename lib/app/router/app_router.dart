import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/motion/goman_page_transitions.dart';
import '../../features/adhkar/presentation/screens/adhkar_screen.dart';
import '../../features/duas/presentation/screens/duas_screen.dart';
import '../../features/prayer_times/presentation/screens/prayer_times_screen.dart';
import '../../features/quran/presentation/screens/quran_saved_ayahs_screen.dart';
import '../../features/quran/presentation/screens/quran_reader_screen.dart';
import '../../features/quran/presentation/screens/quran_screen.dart';
import '../../features/shell/presentation/shell_screen.dart';
import '../../features/shell/presentation/widgets/animated_branch_container.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.adhkar,
    routes: [
      StatefulShellRoute(
        builder: (context, state, navigationShell) {
          return ShellScreen(navigationShell: navigationShell);
        },
        navigatorContainerBuilder: (context, navigationShell, children) {
          return AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.adhkar,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AdhkarScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.quran,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: QuranScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'saved',
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => GomanPageTransitions.push(
                      key: state.pageKey,
                      child: const QuranSavedAyahsScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'read',
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final page = int.tryParse(
                            state.uri.queryParameters['page'] ?? '',
                          ) ??
                          1;
                      final flashSurah =
                          int.tryParse(state.uri.queryParameters['surah'] ?? '');
                      final flashVerse =
                          int.tryParse(state.uri.queryParameters['verse'] ?? '');
                      return GomanPageTransitions.reader(
                        key: state.pageKey,
                        child: QuranReaderScreen(
                          initialPageNumber: page.clamp(1, 604),
                          flashAyahSurah: flashSurah,
                          flashAyahVerse: flashVerse,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.duas,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DuasScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.prayerTimes,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: PrayerTimesScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
