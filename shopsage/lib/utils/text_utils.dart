import 'package:flutter/material.dart';

String formatTime(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// **bold**, # headings aur "- " lists ko sahi text mein badalta hai
List<InlineSpan> parseRichText(String text, TextStyle base) {
  final spans = <InlineSpan>[];
  final lines = text.split('\n');
  final boldRegex = RegExp(r'\*\*(.+?)\*\*');
  final headingRegex = RegExp(r'^#{1,6}\s+');

  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];
    var style = base;

    if (headingRegex.hasMatch(line)) {
      line = line.replaceFirst(headingRegex, '');
      style = base.copyWith(fontWeight: FontWeight.w700);
    }
    if (line.startsWith('- ') || line.startsWith('* ')) {
      line = '•  ${line.substring(2)}';
    }

    var last = 0;
    for (final m in boldRegex.allMatches(line)) {
      if (m.start > last) {
        spans.add(TextSpan(text: line.substring(last, m.start), style: style));
      }
      spans.add(
        TextSpan(
          text: m.group(1),
          style: style.copyWith(fontWeight: FontWeight.w700),
        ),
      );
      last = m.end;
    }
    if (last < line.length) {
      spans.add(TextSpan(text: line.substring(last), style: style));
    }
    if (i < lines.length - 1) {
      spans.add(TextSpan(text: '\n', style: style));
    }
  }
  return spans;
}
