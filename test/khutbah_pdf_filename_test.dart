import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/features/khutbahs/data/khutbah_models.dart';

void main() {
  test('pdf filename mapping replaces spaces with underscores', () {
    expect(
      khutbahPdfFileNameFromTitle('يتخوضون في مال الله'),
      'يتخوضون_في_مال_الله.pdf',
    );
  });

  test('pdf filename trims surrounding whitespace', () {
    expect(
      khutbahPdfFileNameFromTitle('  الجنة دار الكرامة  '),
      'الجنة_دار_الكرامة.pdf',
    );
  });

  test('pdf filename preserves Arabic words without spaces', () {
    expect(
      khutbahPdfFileNameFromTitle('التوحيد'),
      'التوحيد.pdf',
    );
  });
}
