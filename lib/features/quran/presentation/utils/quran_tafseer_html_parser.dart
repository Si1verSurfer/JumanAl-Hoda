import 'package:flutter/foundation.dart';

enum TafseerSpanKind {
  body,
  label,
  quote,
  ayah,
  reference,
}

@immutable
class TafseerTextSpan {
  const TafseerTextSpan({
    required this.text,
    this.kind = TafseerSpanKind.body,
  });

  final String text;
  final TafseerSpanKind kind;

  TafseerTextSpan copyWith({TafseerSpanKind? kind}) {
    return TafseerTextSpan(
      text: text,
      kind: kind ?? this.kind,
    );
  }
}

@immutable
class TafseerParagraph {
  const TafseerParagraph({
    required this.spans,
    this.isHeading = false,
  });

  final List<TafseerTextSpan> spans;
  final bool isHeading;
}

abstract final class QuranTafseerHtmlParser {
  static List<TafseerParagraph> parse(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return const [];

    if (!trimmed.contains('<')) {
      return [_paragraphFromPlain(trimmed)];
    }

    final normalized = _decodeEntities(trimmed)
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    final paragraphs = <TafseerParagraph>[];
    final paragraphMatches =
        RegExp(r'<p[^>]*>(.*?)</p>', dotAll: true).allMatches(normalized);

    if (paragraphMatches.isEmpty) {
      paragraphs.add(_buildParagraph(_parseInline(normalized)));
      return paragraphs;
    }

    for (final match in paragraphMatches) {
      final content = match.group(1) ?? '';
      final spans = _parseInline(content);
      if (spans.isEmpty) continue;
      paragraphs.add(_buildParagraph(spans));
    }

    return paragraphs;
  }

  static TafseerParagraph _paragraphFromPlain(String text) {
    final chunks = text
        .split(RegExp(r'\n\s*\n'))
        .map((chunk) => chunk.trim())
        .where((chunk) => chunk.isNotEmpty);

    if (chunks.length <= 1) {
      return _buildParagraph([TafseerTextSpan(text: text.replaceAll('\n', ' '))]);
    }

    return _buildParagraph(
      chunks
          .map((chunk) => TafseerTextSpan(text: chunk.replaceAll('\n', ' ')))
          .toList(),
    );
  }

  static TafseerParagraph _buildParagraph(List<TafseerTextSpan> spans) {
    final merged = _mergeAdjacent(spans);
    return TafseerParagraph(
      spans: merged,
      isHeading: _looksLikeHeading(merged),
    );
  }

  static bool _looksLikeHeading(List<TafseerTextSpan> spans) {
    if (spans.length != 1 || spans.first.kind != TafseerSpanKind.body) {
      return false;
    }

    final text = spans.first.text.trim();
    if (text.isEmpty || text.length > 90) return false;
    if (text.endsWith('.') || text.endsWith('،') || text.endsWith('؟')) {
      return false;
    }

    return true;
  }

  static List<TafseerTextSpan> _parseInline(String html) {
    final spans = <TafseerTextSpan>[];
    var remaining = html.trim();

    while (remaining.isNotEmpty) {
      final spanOpen = RegExp(r'^<span\s+class="([^"]+)"[^>]*>', caseSensitive: false)
          .firstMatch(remaining);
      if (spanOpen != null) {
        final className = spanOpen.group(1) ?? '';
        remaining = remaining.substring(spanOpen.end);
        final closeIndex = _indexOfClosingTag(remaining, 'span');
        if (closeIndex == -1) break;

        final inner = remaining.substring(0, closeIndex);
        remaining = remaining.substring(closeIndex + 7);
        final kind = _kindForClass(className);
        spans.addAll(_applyKind(_parseInline(inner), kind));
        continue;
      }

      final boldOpen =
          RegExp(r'^<(b|strong)>', caseSensitive: false).firstMatch(remaining);
      if (boldOpen != null) {
        final tag = boldOpen.group(1)!;
        remaining = remaining.substring(boldOpen.end);
        final closeIndex = _indexOfClosingTag(remaining, tag);
        if (closeIndex == -1) break;

        final inner = remaining.substring(0, closeIndex);
        remaining = remaining.substring(closeIndex + tag.length + 3);
        spans.addAll(
          _applyKind(_parseInline(inner), TafseerSpanKind.label),
        );
        continue;
      }

      final textMatch = RegExp(r'^[^<]+').firstMatch(remaining);
      if (textMatch != null) {
        final raw = textMatch.group(0)!;
        remaining = remaining.substring(textMatch.end);
        _appendText(spans, raw, TafseerSpanKind.body);
        continue;
      }

      final unknownTag = RegExp(r'^<[^>]+>').firstMatch(remaining);
      if (unknownTag != null) {
        remaining = remaining.substring(unknownTag.end);
        continue;
      }

      break;
    }

    return _mergeAdjacent(spans);
  }

  static void _appendText(
    List<TafseerTextSpan> spans,
    String raw,
    TafseerSpanKind kind,
  ) {
    final parts = raw.split('\n');
    for (var i = 0; i < parts.length; i++) {
      final text = _normalizeWhitespace(parts[i]);
      if (text.isEmpty) continue;
      spans.add(TafseerTextSpan(text: text, kind: kind));
      if (i < parts.length - 1) {
        spans.add(const TafseerTextSpan(text: '\n', kind: TafseerSpanKind.body));
      }
    }
  }

  static List<TafseerTextSpan> _applyKind(
    List<TafseerTextSpan> spans,
    TafseerSpanKind kind,
  ) {
    return spans
        .map(
          (span) => span.kind == TafseerSpanKind.body
              ? span.copyWith(kind: kind)
              : span,
        )
        .toList();
  }

  static TafseerSpanKind _kindForClass(String className) {
    final normalized = className.toLowerCase();
    if (normalized.contains('red')) return TafseerSpanKind.quote;
    if (normalized.contains('green') || normalized.contains('arabic')) {
      return TafseerSpanKind.ayah;
    }
    if (normalized.contains('reference')) return TafseerSpanKind.reference;
    if (normalized.contains('blue')) return TafseerSpanKind.label;
    return TafseerSpanKind.body;
  }

  static int _indexOfClosingTag(String input, String tag) {
    return input.toLowerCase().indexOf('</$tag>');
  }

  static List<TafseerTextSpan> _mergeAdjacent(List<TafseerTextSpan> spans) {
    if (spans.isEmpty) return spans;

    final merged = <TafseerTextSpan>[];
    for (final span in spans) {
      if (span.text.isEmpty) continue;

      final last = merged.isEmpty ? null : merged.last;
      if (last != null &&
          last.kind == span.kind &&
          span.text != '\n' &&
          last.text != '\n') {
        merged[merged.length - 1] =
            TafseerTextSpan(text: '${last.text}${span.text}', kind: last.kind);
      } else {
        merged.add(span);
      }
    }
    return merged;
  }

  static String _decodeEntities(String input) {
    return input
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
  }

  static String _normalizeWhitespace(String input) {
    return input.replaceAll(RegExp(r'[ \t]+'), ' ').trim();
  }
}
