import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';

class CustomRefreshIndicator extends StatefulWidget {
  const CustomRefreshIndicator({
    Key? key,
    required this.child,
    required this.reset,
  }) : super(key: key);

  final Widget child;
  final Future<void> Function() reset;
  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(primaryColor),
      onRefresh: widget.reset,
      child: widget.child,
    );
  }
}
