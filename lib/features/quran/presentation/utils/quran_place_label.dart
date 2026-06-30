String quranPlaceLabelArabic(String place) {
  return switch (place) {
    'Makkah' => 'مكية',
    'Madinah' => 'مدنية',
    _ => place,
  };
}
