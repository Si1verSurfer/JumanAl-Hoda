import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/features/khutbahs/data/khutbah_models.dart';
import 'package:goman_alhoda/features/khutbahs/data/khutbah_repository.dart';

void main() {
  final sample = [
    KhutbahIndexEntry(
      id: 1,
      title: 'يتخوضون في مال الله',
      slug: 'slug-1',
      categoryText: 'المعاملات',
      authorName: 'الشيخ عبدالعزيز',
      pdfFileName: 'يتخوضون_في_مال_الله.pdf',
      createdAt: '2024-08-20 09:10:09',
    ),
    KhutbahIndexEntry(
      id: 2,
      title: 'الجنة دار الكرامة',
      slug: 'slug-2',
      categoryText: 'الحياة الآخرة',
      authorName: 'الشيخ محمد',
      pdfFileName: 'الجنة_دار_الكرامة.pdf',
      createdAt: '2024-07-01 09:10:09',
    ),
  ];

  test('filter by category returns only matching khutbahs', () {
    final repo = KhutbahRepository(sample);
    final results = repo.filter(category: 'المعاملات');
    expect(results, hasLength(1));
    expect(results.first.id, 1);
  });

  test('search matches title and author', () {
    final repo = KhutbahRepository(sample);
    expect(repo.filter(query: 'الجنة'), hasLength(1));
    expect(repo.filter(query: 'محمد'), hasLength(1));
    expect(repo.filter(query: 'xyz'), isEmpty);
  });

  test('categories are counted and sorted by count', () {
    final repo = KhutbahRepository([
      ...sample,
      KhutbahIndexEntry(
        id: 3,
        title: 'معاملة أخرى',
        slug: 'slug-3',
        categoryText: 'المعاملات',
        authorName: 'الشيخ',
        pdfFileName: 'x.pdf',
      ),
    ]);
    final categories = repo.categories();
    expect(categories.first.name, 'المعاملات');
    expect(categories.first.count, 2);
  });

  test('limits categories to top eight by count', () {
    final entries = <KhutbahIndexEntry>[
      for (var i = 0; i < 10; i++)
        KhutbahIndexEntry(
          id: i + 1,
          title: 'خطبة $i',
          slug: 'slug-$i',
          categoryText: 'تصنيف $i',
          authorName: 'الشيخ',
          pdfFileName: 'khutbah_$i.pdf',
        ),
      for (var i = 0; i < 5; i++)
        KhutbahIndexEntry(
          id: 100 + i,
          title: 'خطبة إضافية $i',
          slug: 'extra-$i',
          categoryText: 'تصنيف 0',
          authorName: 'الشيخ',
          pdfFileName: 'extra_$i.pdf',
        ),
    ];

    final repo = KhutbahRepository(entries);
    expect(repo.categories(), hasLength(8));
    expect(repo.categories().first.name, 'تصنيف 0');
    expect(repo.categories().first.count, 6);
    expect(
      repo.all.any((entry) => entry.categoryText == 'تصنيف 9'),
      isFalse,
    );
  });

  test('excludes blocked categories and non-pdf entries', () {
    final repo = KhutbahRepository([
      ...sample,
      KhutbahIndexEntry(
        id: 3,
        title: 'سياسي',
        slug: 'slug-3',
        categoryText: 'السياسة والشأن العام',
        authorName: 'الشيخ',
        pdfFileName: 'سياسي.pdf',
      ),
      KhutbahIndexEntry(
        id: 4,
        title: 'Word only',
        slug: 'slug-4',
        categoryText: 'المعاملات',
        authorName: 'الشيخ',
        pdfFileName: 'word.doc',
      ),
    ]);

    expect(repo.all, hasLength(2));
    expect(
      repo.categories().any((c) => c.name == 'السياسة والشأن العام'),
      isFalse,
    );
  });
}
