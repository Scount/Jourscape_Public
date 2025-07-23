import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jourscape/features/map/presentation/provider/map_provider.dart';
import 'package:jourscape/shared_widgets/square_button.dart';

class MapScreenOverlay extends ConsumerWidget {
  const MapScreenOverlay({this.jumpToOwnLocation, super.key});
  final Function? jumpToOwnLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String mapState = ref.watch(mapStateNotifierProvider);
    List<Widget> widgets = [];
    if (mapState == 'normal') {
      // widgets.add(
      //   const Positioned(
      //     bottom: 180,
      //     right: 20,
      //     child: SquareButton(icon: Icons.layers),
      //   ),
      // );
      widgets.add(
        Positioned(
          bottom: 120,
          left: 20,
          child: SquareButton(
            icon: Icons.history,
            onTap: () {
              // set state of map screen to history
              // set start date to today
              ref.read(mapStateNotifierProvider.notifier).changeToHistory();
              ref.read(historyDateProvider.notifier).state = DateTime.now();
            },
          ),
        ),
      );
      widgets.add(
        Positioned(
          bottom: 120,
          right: 20,
          child: Stack(
            children: [
              Positioned(
                child: SquareButton(
                  icon: Icons.location_searching,
                  onTap: () {
                    jumpToOwnLocation?.call();
                  },
                ),
              ),
              // If position tracking is activated, a red dot is shown in the middle of the tracking icon
              Positioned(
                bottom: 20,
                top: 20,
                left: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (mapState == 'history') {
      widgets.add(
        Positioned(
          top: 20,
          left: 20,
          child: SafeArea(
            child: SquareButton(
              icon: Icons.arrow_back,
              onTap: () {
                ref.read(mapStateNotifierProvider.notifier).changeToNormal();
              },
            ),
          ),
        ),
      );
    }

    return Stack(children: widgets);
  }
}
