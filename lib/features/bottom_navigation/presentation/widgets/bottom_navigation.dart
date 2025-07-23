import 'package:flutter/material.dart';
import 'package:jourscape/core/design/shadow.dart';

class BottomNavigationItem {
  final String name;
  final IconData icon;
  final int id;

  BottomNavigationItem({
    required this.name,
    required this.icon,
    required this.id,
  });
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    required this.selectedIndex,
    required this.previousSelectedIndex,
    required this.animationValue,
    required this.onTap,
    required this.items,
    super.key,
  });
  final Function(int) onTap;
  final int selectedIndex;
  final int previousSelectedIndex;
  final double animationValue;
  final List<BottomNavigationItem> items;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    List<Widget> itemWidgets = [];
    for (int i = 0; i < widget.items.length; i++) {
      itemWidgets.add(
        Expanded(
          child: GestureDetector(
            onTap: () => widget.onTap.call(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: widget.selectedIndex == i
                      ? 35 * widget.animationValue
                      : widget.previousSelectedIndex == i
                      ? 35 * (1 - widget.animationValue)
                      : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xff064a59),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 3),
                Expanded(
                  child: SizedBox(
                    width: 35,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: widget.selectedIndex == i
                                ? widget.animationValue
                                : widget.previousSelectedIndex == i
                                ? 1 - widget.animationValue
                                : 0,
                            child: Icon(
                              widget.items[i].icon,
                              color: const Color(0xff064a59),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Icon(
                            widget.items[i].icon,
                            color: const Color(
                              0xff064a59,
                            ).withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      height: 56,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 50),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffe8fcf3),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: shadow,
      ),
      child: Row(children: itemWidgets),
    );
  }
}
