import 'package:flutter/material.dart';
import 'package:jourscape/core/design/shadow.dart';
import 'package:go_router/go_router.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/search');
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xffe8fcf3),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: shadow,
        ),
        child: const Row(
          children: [
            Expanded(
              child: Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 0)),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.search, color: Color(0xff064a59)),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
