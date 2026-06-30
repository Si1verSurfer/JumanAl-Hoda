import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/quran_tafseer_repository.dart';

final quranTafseerRepositoryProvider = Provider<QuranTafseerRepository>(
  (ref) => QuranTafseerRepository(),
);
