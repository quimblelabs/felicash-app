import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
    this.currentIndex, {
    required this.onTabChanged,
    this.onAddPressed,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    return Theme(
      data: theme.copyWith(
        splashColor: Colors.transparent,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SizedBox(
            height: 80,
            width: (screenWidth * .8).clamp(300.0, 400.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.xlg),
              child: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      icon: currentIndex == 0
                          ? IconsaxPlusBold.home
                          : IconsaxPlusLinear.home,
                      label: 'Home',
                      isSelected: currentIndex == 0,
                      onTap: () => onTabChanged(0),
                    ),
                    _NavBarItem(
                      icon: currentIndex == 1
                          ? IconsaxPlusBold.arrow_swap_horizontal
                          : IconsaxPlusLinear.arrow_swap_horizontal,
                      label: 'Transactions',
                      isSelected: currentIndex == 1,
                      onTap: () => onTabChanged(1),
                    ),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        foregroundColor: theme.colorScheme.onSecondaryContainer,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        elevation: 0,
                      ),
                      onPressed: onAddPressed,
                      icon: const Icon(Icons.add),
                    ),
                    _NavBarItem(
                      icon: currentIndex == 2
                          ? IconsaxPlusBold.wallet
                          : IconsaxPlusLinear.wallet,
                      label: 'Wallet',
                      isSelected: currentIndex == 2,
                      onTap: () => onTabChanged(2),
                    ),
                    _NavBarItem(
                      icon: currentIndex == 3
                          ? IconsaxPlusBold.user
                          : IconsaxPlusLinear.user,
                      label: 'Personal',
                      isSelected: currentIndex == 3,
                      onTap: () => onTabChanged(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onPrimary;
    final unSelectedColor = theme.colorScheme.onPrimaryContainer;
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      icon: Icon(icon, color: isSelected ? color : unSelectedColor),
    );
  }
}
