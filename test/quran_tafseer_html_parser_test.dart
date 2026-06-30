import 'package:flutter_test/flutter_test.dart';
import 'package:goman_alhoda/features/quran/presentation/utils/quran_tafseer_html_parser.dart';

void main() {
  test('parses paragraph and styled spans', () {
    const html =
        '<p lang="ar" class="ar ">'
        'قال أبو جعفر :'
        '<span class="blue"> وتأويل قول القائل :</span> '
        '<span class="arabic qpc-hafs green">( أعوذ )</span>'
        '</p>';

    final paragraphs = QuranTafseerHtmlParser.parse(html);

    expect(paragraphs, hasLength(1));
    expect(paragraphs.first.isHeading, isFalse);
    expect(
      paragraphs.first.spans.map((span) => span.kind).toSet(),
      containsAll({
        TafseerSpanKind.body,
        TafseerSpanKind.label,
        TafseerSpanKind.ayah,
      }),
    );
  });

  test('detects short section headings', () {
    const html = '<p>القول في تأويل الاستعاذة</p>';

    final paragraphs = QuranTafseerHtmlParser.parse(html);

    expect(paragraphs, hasLength(1));
    expect(paragraphs.first.isHeading, isTrue);
  });

  test('falls back to plain text', () {
    const plain = 'نص تفسير بسيط بدون وسوم.';

    final paragraphs = QuranTafseerHtmlParser.parse(plain);

    expect(paragraphs, hasLength(1));
    expect(paragraphs.first.spans.single.text, plain);
  });
}
