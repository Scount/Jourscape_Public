import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jourscape/features/bottom_navigation/presentation/widgets/bottom_navigation.dart';
import 'package:jourscape/features/bottom_navigation/domain/methods/calculate_animation.dart';
import 'package:jourscape/features/bottom_navigation/domain/methods/calculate_indexes.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({
    required this.screens,
    required this.items,
    this.showBottomNavigationItems = true,
    super.key,
  }) : assert(screens.length == items.length);
  final List<Widget> screens;
  final List<BottomNavigationItem> items;
  final bool showBottomNavigationItems;

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late PageController _pageController;
  late int previousSelectedIndex;
  late int currentSelectedIndex;
  // Value between 0 and 1
  late double animationValue;

  final Duration animationDuration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {
        setState(() {
          animationValue = animationController.value;
        });
      });
    _pageController = PageController();
    _pageController.addListener(() {
      // left side out of range
      if (_pageController.offset < 0) {
        return;
      }
      // right side out of range
      if (_pageController.position.outOfRange) {
        return;
      }

      ScrollDirection scrollDirection =
          _pageController.position.userScrollDirection;
      double sumOfScreenSizes =
          _pageController.position.viewportDimension *
          (widget.screens.length - 1);
      // left swipe
      if (scrollDirection == ScrollDirection.reverse) {
        final (int previous, int current) = calculateCurrentAndSelectedIndex(
          sumOfScreenSizes,
          _pageController.offset,
          widget.screens.length,
        );
        previousSelectedIndex = previous;
        currentSelectedIndex = current;
        animationValue = calculateAnimationValue(
          _pageController.position.viewportDimension,
          _pageController.offset,
        );
      }
      // right swipe
      if (scrollDirection == ScrollDirection.forward) {
        final (int previous, int current) = calculateCurrentAndSelectedIndex(
          sumOfScreenSizes,
          _pageController.offset,
          widget.screens.length,
          reverse: true,
        );
        previousSelectedIndex = previous;
        currentSelectedIndex = current;
        animationValue = calculateAnimationValue(
          _pageController.position.viewportDimension,
          _pageController.offset,
          reverse: true,
        );
      }
      setState(() {});
    });

    animationValue = 0;
    previousSelectedIndex = 0;
    currentSelectedIndex = 0;
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [];
    for (int i = 0; i < widget.screens.length; i++) {
      screens.add(
        Opacity(
          opacity: currentSelectedIndex == i
              ? animationValue < 0.3
                    ? 0.3
                    : animationValue
              : previousSelectedIndex == i
              ? (1 - animationValue) < 0.3
                    ? 0.3
                    : 1 - animationValue
              : 0.3,
          child: widget.screens[i],
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int value) {},
              children: screens,
            ),
          ),
          if (widget.showBottomNavigationItems) ...[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomNavigation(
                selectedIndex: currentSelectedIndex,
                previousSelectedIndex: previousSelectedIndex,
                animationValue: animationValue,
                onTap: (int index) {
                  setState(() {
                    previousSelectedIndex = currentSelectedIndex;
                    currentSelectedIndex = index;
                    animationController.reset();
                    animationController.forward();
                    _pageController.jumpTo(
                      index * _pageController.position.viewportDimension,
                    );
                  });
                },
                items: widget.items,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
