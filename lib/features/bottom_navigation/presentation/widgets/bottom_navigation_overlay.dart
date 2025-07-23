import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jourscape/features/map/presentation/provider/map_provider.dart';
import 'package:jourscape/features/wip_search/search_field.dart';

class BottomNavigationOverlay extends ConsumerWidget {
  const BottomNavigationOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String mapState = ref.watch(mapStateNotifierProvider);
    List<Widget> widgets = [];
    if (mapState == 'normal') {
      widgets.add(
        const Positioned(
          top: 20,
          right: 20,
          left: 20,
          child: SafeArea(child: SearchField()),
        ),
      );
    }

    return Stack(children: widgets);
  }
}
