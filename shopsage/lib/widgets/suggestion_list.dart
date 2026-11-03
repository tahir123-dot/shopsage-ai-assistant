import 'package:flutter/material.dart';
import '../core/theme.dart';

class SuggestionList extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onTap;

  const SuggestionList({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          return Material(
            color: kSurface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onTap(suggestions[i]),
              child: Container(
                width: 160,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.centerLeft,
                child: Text(
                  suggestions[i],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: kInk,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
