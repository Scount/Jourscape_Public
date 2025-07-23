import 'package:flutter/material.dart';
import 'package:jourscape/core/design/shadow.dart';

class SquareButton extends StatefulWidget {
  const SquareButton({this.icon, this.onTap, super.key});
  final IconData? icon;
  final Function? onTap;

  @override
  State<SquareButton> createState() => _SquareButtonState();
}

class _SquareButtonState extends State<SquareButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: const Color(0xffe8fcf3),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: shadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap != null ? () => widget.onTap?.call() : null,
          child: widget.icon != null
              ? Center(child: Icon(widget.icon, color: const Color(0xff064a59)))
              : null,
        ),
      ),
    );
  }
}
