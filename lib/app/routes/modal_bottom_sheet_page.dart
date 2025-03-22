import 'package:flutter/material.dart';

class ModelBottomSheetPage<T> extends Page<T> {
  const ModelBottomSheetPage({
    required this.builder,
    this.isScrollControlled = false,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.enableDrag = true,
    this.isDismissible = true,
  });

  final WidgetBuilder builder;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool enableDrag;
  final bool isDismissible;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      builder: builder,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      modalBarrierColor: Colors.black54,
      settings: this,
    );
  }
}
