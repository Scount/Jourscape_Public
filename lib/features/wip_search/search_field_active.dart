import 'package:flutter/material.dart';
import 'package:jourscape/core/design/shadow.dart';
import 'package:go_router/go_router.dart';

class SearchFieldActive extends StatefulWidget {
  const SearchFieldActive({super.key});

  @override
  State<SearchFieldActive> createState() => _SearchFieldActiveState();
}

class _SearchFieldActiveState extends State<SearchFieldActive> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  void onSearch() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xffe8fcf3),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: shadow,
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: const Icon(Icons.arrow_back, color: Color(0xff064a59)),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: TextField(
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                  onTapOutside: (event) {
                    focusNode.unfocus();
                  },
                ),
              ),
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
