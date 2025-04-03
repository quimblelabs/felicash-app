import 'dart:math' as math;
import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AddTransactionMenuButton extends StatefulWidget {
  const AddTransactionMenuButton({super.key});

  @override
  State<AddTransactionMenuButton> createState() =>
      _AddTransactionMenuButtonState();
}

class _AddTransactionMenuButtonState extends State<AddTransactionMenuButton>
    with SingleTickerProviderStateMixin {
  late final OverlayPortalController _overlayPortalController;
  late final AnimationController _animationController;
  final GlobalKey _childKey = GlobalKey();
  // Offset childPos = Offset.zero;
  bool _visible = false;
  VoidCallback? _onClosedCallback;

  @override
  void initState() {
    _overlayPortalController = OverlayPortalController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 210),
      reverseDuration: const Duration(milliseconds: 210),
    )..addStatusListener(_onAnimationStatusChanged);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _calculateChildPosition();
    // });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _onAnimationReverseCompleted();
    } else if (status == AnimationStatus.forward) {
      _onAnimationStart();
    }
  }

  void _onAnimationStart() {
    _overlayPortalController.show();
    _visible = true;
  }

  void _onAnimationReverseCompleted() {
    _overlayPortalController.hide();
    _visible = false;
    _onClosedCallback?.call();
    _onClosedCallback = null;
  }

  // void _calculateChildPosition() {
  //   final childRenderBox =
  //       _childKey.currentContext!.findRenderObject()! as RenderBox;
  //   final childPosition = childRenderBox.localToGlobal(Offset.zero);
  //   childPos = childPosition;
  // }

  void _toggle({required bool visible}) {
    if (visible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.secondaryContainer,
        foregroundColor: theme.colorScheme.onSecondaryContainer,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        elevation: 0,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        _toggle(visible: !_visible);
      },
      icon: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animationController.value * (0.25 * math.pi),
            child: child,
          );
        },
        child: const Icon(Icons.add),
      ),
    );

    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: (context) {
        return _buildOverlay(context, child);
      },
      child: SizedBox(
        key: _childKey,
        child: child,
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, Widget child) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final childRenderBox =
        _childKey.currentContext!.findRenderObject()! as RenderBox;
    final childPos = childRenderBox.localToGlobal(Offset.zero);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GestureDetector(
          onTap: () {
            _toggle(visible: false);
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 4,
            ),
            child: Container(
              height: size.height,
              width: size.width,
              color: theme.colorScheme.surface.withValues(
                alpha: .45 * _animationController.value,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: size.height - childPos.dy + AppSpacing.xlg,
          child: SizedBox(
            width: size.width * .6,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                if (childPos == Offset.zero) {
                  return const SizedBox.shrink();
                }
                return Column(
                  spacing: AppRadius.md,
                  children: [
                    Transform.translate(
                      offset: Offset(
                        (1 - _animationController.value) * -120,
                        0,
                      ),
                      child: Opacity(
                        opacity: _animationController.value,
                        child: FilledButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _onClosedCallback = () {
                              // TODO(tuanhm):  Add recept scanner
                            };
                            _toggle(visible: false);
                          },
                          icon: const Icon(IconsaxPlusLinear.scanner),
                          label: const Text('Recept Scanner'),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                        (1 - _animationController.value) * 80,
                        0,
                      ),
                      child: Opacity(
                        opacity: _animationController.value,
                        child: FilledButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _onClosedCallback = () {
                              context.pushNamed(AppRouteNames.voiceTransaction);
                            };
                            _toggle(visible: false);
                          },
                          icon: const Icon(IconsaxPlusBold.microphone_2),
                          label: const Text('AI Voice Input'),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                        (1 - _animationController.value) * -60,
                        0,
                      ),
                      child: Opacity(
                        opacity: _animationController.value,
                        child: FilledButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _onClosedCallback = () async {
                              final result = await context.pushNamed(
                                AppRouteNames.transactionCreation,
                              );
                            };
                            _toggle(visible: false);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Manual Entry'),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Positioned(
          left: childPos.dx,
          top: childPos.dy,
          child: child,
        ),
      ],
    );
  }
}

/// Non-nullable version of ColorTween.
class ColorTween extends Tween<Color> {
  ColorTween({required Color begin, required Color end})
      : super(begin: begin, end: end);

  @override
  Color lerp(double t) => Color.lerp(begin, end, t)!;
}
