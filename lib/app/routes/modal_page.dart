import 'package:flutter/material.dart';

const _kScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;

class ModalPage<T> extends Page<T> {
  const ModalPage({
    required this.builder,
    required this.isScrollControlled,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.barrierColor,
    this.scrollControlDisabledMaxHeightRatio =
        _kScrollControlDisabledMaxHeightRatio,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showDragHandle,
    this.useSafeArea = false,
    this.barrierLabel,
    this.barrierOnTapHint,
    this.anchorPoint,
    this.sheetAnimationStyle,
  });

  final WidgetBuilder builder;

  /// The bottom sheet's background color
  final Color? backgroundColor;

  /// The z-coordinate at which to place the material relative to its parent
  final double? elevation;

  /// The shape of the bottom sheet
  final ShapeBorder? shape;

  /// How to clip the content of the bottom sheet
  final Clip? clipBehavior;

  /// Constraints for the bottom sheet
  final BoxConstraints? constraints;

  /// Color of the modal barrier that darkens the screen behind the sheet
  final Color? barrierColor;

  /// Whether this is a route for a bottom sheet that will utilize [DraggableScrollableSheet]
  final bool isScrollControlled;

  /// The max height constraint ratio when [isScrollControlled] is false
  final double scrollControlDisabledMaxHeightRatio;

  /// Whether the bottom sheet will be dismissed when user taps on the scrim
  final bool isDismissible;

  /// Whether the bottom sheet can be dragged up and down and dismissed by swiping
  final bool enableDrag;

  /// Whether to show a drag handle at the top of the sheet
  final bool? showDragHandle;

  /// Whether to avoid system intrusions on the top, left, and right
  final bool useSafeArea;

  /// Label for the barrier for accessibility
  final String? barrierLabel;

  /// Semantic hint text for barrier tap
  final String? barrierOnTapHint;

  /// Anchor point for the sheet
  final Offset? anchorPoint;

  /// Animation style for the sheet
  final AnimationStyle? sheetAnimationStyle;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      settings: this,
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      modalBarrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      barrierLabel: barrierLabel,
      barrierOnTapHint: barrierOnTapHint,
      anchorPoint: anchorPoint,
      sheetAnimationStyle: sheetAnimationStyle,
    );
  }
}
