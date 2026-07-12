import 'package:flutter/material.dart';

import '../../features/adhkar/presentation/screens/allah_names_screen.dart';
import '../../features/adhkar/presentation/screens/guides/dua_dhikr_screen.dart';
import '../../features/adhkar/presentation/screens/guides/dua_etiquette_screen.dart';
import '../../features/adhkar/presentation/screens/guides/duha_screen.dart';
import '../../features/adhkar/presentation/screens/guides/forbidden_times_screen.dart';
import '../../features/adhkar/presentation/screens/guides/jumuah_screen.dart';
import '../../features/adhkar/presentation/screens/guides/qada_ramadan_screen.dart';
import '../../features/adhkar/presentation/screens/guides/rawatib_screen.dart';
import '../../features/adhkar/presentation/screens/worship_category_screen.dart';

/// Maps worship category ids to their detail screens.
Widget worshipScreenFor(String categoryId) {
  return switch (categoryId) {
    AllahNamesScreen.categoryId => const AllahNamesScreen(),
    RawatibScreen.categoryId => const RawatibScreen(),
    JumuahScreen.categoryId => const JumuahScreen(),
    DuhaScreen.categoryId => const DuhaScreen(),
    ForbiddenTimesScreen.categoryId => const ForbiddenTimesScreen(),
    DuaDhikrScreen.categoryId => const DuaDhikrScreen(),
    DuaEtiquetteScreen.categoryId => const DuaEtiquetteScreen(),
    QadaRamadanScreen.categoryId => const QadaRamadanScreen(),
    _ => WorshipCategoryScreen(categoryId: categoryId),
  };
}

String worshipRouteFor(String categoryId) =>
    WorshipCategoryScreen.routeFor(categoryId);
