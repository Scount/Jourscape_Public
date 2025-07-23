import 'package:flutter/material.dart';
import 'package:jourscape/features/map/presentation/widgets/horizontal_date_selector.dart';
import 'package:jourscape/core/design/shadow.dart';

class MapBottomSheet extends StatefulWidget {
  const MapBottomSheet({this.onDateChanged, super.key});
  final Function(DateTime)? onDateChanged;

  @override
  State<MapBottomSheet> createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      snapSizes: [0.15, 0.5, 0.8],
      minChildSize: 0.15,
      maxChildSize: 0.8,
      snap: true,
      builder: (BuildContext context, scrollController) {
        return Container(
          height: 100,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: shadow,
          ),

          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    child: HorizontalDateSelector(
                      onDateChanged: widget.onDateChanged,
                    ),
                    height: 75,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
