import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/prayer_times/notifications/prayer_notification_navigation.dart';
import '../../core/motion/goman_page_transitions.dart';
import '../../features/adhkar/presentation/screens/allah_name_detail_screen.dart';
import '../../features/adhkar/presentation/screens/adhkar_screen.dart';
import '../../features/khutbahs/presentation/screens/khutbah_pdf_viewer_screen.dart';
import '../../features/khutbahs/presentation/screens/khutbahs_screen.dart';
import '../../features/prayer_times/presentation/screens/prayer_times_screen.dart';
import '../../features/adhkar/presentation/screens/tasbih_screen.dart';
import '../../features/qiblah/presentation/screens/qiblah_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/quran/presentation/screens/quran_saved_ayahs_screen.dart';
import '../../features/quran/presentation/screens/quran_reader_screen.dart';
import '../../features/quran/presentation/screens/quran_screen.dart';
import '../../features/shell/presentation/shell_screen.dart';
import '../../features/shell/presentation/widgets/animated_branch_container.dart';
import 'routes.dart';
import 'worship_category_route.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Root navigator key for notification deep links and full-screen routes.
GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

final routerProvider = Provider<GoRouter>((ref) {
  PrayerNotificationNavigation.bind(_rootNavigatorKey);
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
                routes: [
                  GoRoute(
                    path: 'category/:categoryId',
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final categoryId =
                          state.pathParameters['categoryId'] ?? '';
                      return GomanPageTransitions.push(
                        key: state.pageKey,
                        child: worshipScreenFor(categoryId),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'allah-name/:nameId',
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final nameId = state.pathParameters['nameId'] ?? '';
                      return GomanPageTransitions.push(
                        key: state.pageKey,
                        child: AllahNameDetailScreen(nameId: nameId),
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
                path: Routes.khutbahs,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: KhutbahsScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'pdf/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      if (id == null) {
                        return const NoTransitionPage(child: KhutbahsScreen());
                      }
                      return GomanPageTransitions.push(
                        key: state.pageKey,
                        child: KhutbahPdfViewerScreen(khutbahId: id),
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
                path: Routes.prayerTimes,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: PrayerTimesScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.qiblah,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => GomanPageTransitions.push(
          key: state.pageKey,
          child: const QiblahScreen(),
        ),
      ),
      GoRoute(
        path: Routes.tasbih,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => GomanPageTransitions.push(
          key: state.pageKey,
          child: const TasbihScreen(),
        ),
      ),
      GoRoute(
        path: Routes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => GomanPageTransitions.push(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),
    ],
  );
});
