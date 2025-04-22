import 'package:app_ui/app_ui.dart';
import 'package:felicash/transaction/widgets/add_transaction_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
    this.currentIndex, {
    required this.onTabChanged,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        splashColor: Colors.transparent,
      ),
      child: BottomAppBar(
        child: SafeArea(
          child: SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: _NavBarItem(
                    icon: currentIndex == 0
                        ? IconsaxPlusBold.chart
                        : IconsaxPlusLinear.chart_3,
                    label: 'Overview'.hardCoded,
                    isSelected: currentIndex == 0,
                    onTap: () => onTabChanged(0),
                  ),
                ),
                Expanded(
                  child: _NavBarItem(
                    icon: currentIndex == 1
                        ? IconsaxPlusBold.arrow_swap_horizontal
                        : IconsaxPlusLinear.arrow_swap_horizontal,
                    label: 'Transactions'.hardCoded,
                    isSelected: currentIndex == 1,
                    onTap: () => onTabChanged(1),
                  ),
                ),
                const Expanded(child: AddTransactionMenuButton()),
                Expanded(
                  child: _NavBarItem(
                    icon: currentIndex == 2
                        ? IconsaxPlusBold.wallet
                        : IconsaxPlusLinear.wallet,
                    label: 'Wallets'.hardCoded,
                    isSelected: currentIndex == 2,
                    onTap: () => onTabChanged(2),
                  ),
                ),
                Expanded(
                  child: _NavBarItem(
                    icon: currentIndex == 3
                        ? IconsaxPlusBold.user
                        : IconsaxPlusLinear.user,
                    label: 'Personal'.hardCoded,
                    isSelected: currentIndex == 3,
                    onTap: () => onTabChanged(3),
                  ),
                ),
              ],
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
    final effectiveColor = isSelected ? color : unSelectedColor;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.xs,
        children: [
          Icon(icon, color: effectiveColor),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: effectiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
