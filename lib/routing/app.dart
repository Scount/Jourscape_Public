import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jourscape/features/map/presentation/provider/map_provider.dart';
import 'package:jourscape/features/bottom_navigation/presentation/widgets/bottom_navigation.dart';
import 'package:jourscape/features/bottom_navigation/presentation/widgets/bottom_navigation_overlay.dart';
import 'package:jourscape/features/bottom_navigation/presentation/widgets/custom_bottom_navigation.dart';
import 'package:jourscape/features/wip_journey/list_screen.dart';
import 'package:jourscape/features/map/presentation/pages/map_screen.dart';

class AppScreens extends ConsumerStatefulWidget {
  const AppScreens({super.key});

  @override
  ConsumerState<AppScreens> createState() => _AppScreensState();
}

class _AppScreensState extends ConsumerState<AppScreens> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBottomNavigation(
          screens: [
            const MapScreen(),
            const ListScreen(),
            Container(color: Colors.blue),
            Container(color: Colors.orange),
          ],
          items: [
            BottomNavigationItem(id: 0, icon: Icons.map, name: 'Map'),
            BottomNavigationItem(id: 1, icon: Icons.list, name: 'Journey'),
            BottomNavigationItem(id: 3, icon: Icons.flag, name: 'Flags'),
            BottomNavigationItem(id: 4, icon: Icons.person, name: 'Person'),
          ],
          showBottomNavigationItems:
              ref.watch(mapStateNotifierProvider) == 'normal',
        ),
        const Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: BottomNavigationOverlay(),
        ),
      ],
    );
  }
}
