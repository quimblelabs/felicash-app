import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ScrollToTopButton extends StatefulWidget {
  const ScrollToTopButton({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final showButton = widget.scrollController.hasClients &&
        widget.scrollController.offset > MediaQuery.of(context).size.height;

    if (showButton != _showButton) {
      setState(() {
        _showButton = showButton;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showButton ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _showButton ? 1.0 : 0.0,
          child: Padding(
            padding: const EdgeInsets.only(
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
            ),
            child: FloatingActionButton(
              onPressed: () {
                widget.scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(IconsaxPlusLinear.arrow_up_2),
            ),
          ),
        ),
      ),
    );
  }
}
