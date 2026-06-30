import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Last mushaf page the user was reading (1–604).
final quranLastPageProvider = StateProvider<int>((ref) => 1);
