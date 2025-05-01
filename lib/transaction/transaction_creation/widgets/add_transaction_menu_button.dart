import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/l10n/l10n.dart';
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
  late final Animation<double> _opacityAnimation;
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
    _opacityAnimation = _animationController.drive(
      CurveTween(curve: Curves.easeInOut),
    );
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

  void _toggle({required bool visible}) {
    if (visible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = IconButton.filledTonal(
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        elevation: 0,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        _toggle(visible: !_visible);
      },
      icon: const Icon(Icons.add),
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
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final childRenderBox =
        _childKey.currentContext!.findRenderObject()! as RenderBox;
    final childPos = childRenderBox.localToGlobal(Offset.zero);
    return TextButtonTheme(
      data: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          textStyle: theme.textTheme.bodyLarge,
          alignment: Alignment.centerLeft,
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            onTap: () {
              _toggle(visible: false);
            },
            child: AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) => BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 40 * _opacityAnimation.value,
                  sigmaY: 40 * _opacityAnimation.value,
                ),
                child: Container(
                  height: size.height,
                  width: size.width,
                  color: theme.colorScheme.surface.withValues(
                    alpha: .6 * _opacityAnimation.value,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height - childPos.dy + AppSpacing.xlg,
            child: AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, _) {
                return SizedBox(
                  width: size.width * .5,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      spacing: AppRadius.md,
                      children: [
                        Transform.translate(
                          offset: Offset(
                            0,
                            (1 - _animationController.value) * 120,
                          ),
                          child: _ActionButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _onClosedCallback = () {
                                // TODO(tuanhm):  Add recept scanner
                              };
                              _toggle(visible: false);
                            },
                            icon: IconsaxPlusBold.scanner,
                            label: l10n
                                .addTransactionMenuButtonReceptScannerButtonText,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                            0,
                            (1 - _animationController.value) * 80,
                          ),
                          child: _ActionButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _onClosedCallback = () {
                                context.pushNamed(AppRouteNames.aiAssistant);
                              };
                              _toggle(visible: false);
                            },
                            icon: FeliCashIcons.magic,
                            label:
                                l10n.addTransactionMenuButtonAIInputButtonText,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                            0,
                            (1 - _animationController.value) * 60,
                          ),
                          child: _ActionButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _onClosedCallback = () async {
                                await context.pushNamed(
                                  AppRouteNames.transactionCreation,
                                );
                              };
                              _toggle(visible: false);
                            },
                            icon: IconsaxPlusBold.money_add,
                            label: l10n
                                .addTransactionMenuButtonManualInputButtonText,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Icon(
            icon,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
      label: Text(label),
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
