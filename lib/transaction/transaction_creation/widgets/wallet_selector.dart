import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:wallet_repository/wallet_repository.dart';

typedef WalletPickerValueChanged = void Function(
  BaseWalletModel from,
  BaseWalletModel to,
);

/// Creates a new [WalletSelector] for selecting a wallet.
typedef PickWalletCallback = void Function(
  BaseWalletModel? current,
  BaseWalletModel? otherWallet,
  // ignore: avoid_positional_boolean_parameters
  bool isFromWallet,
);

/// Creates a new [WalletSelector] for selecting a wallet.
class WalletSelector extends StatefulWidget {
  /// Creates a new [WalletSelector] for selecting a wallet.
  const WalletSelector({
    required this.wallet,
    this.toWallet,
    this.isTransfer = false,
    this.onChanged,
    this.onPickWallet,
    super.key,
  });

  /// The current wallet.
  final BaseWalletModel? wallet;

  /// The current wallet to transfer to.
  final BaseWalletModel? toWallet;

  /// This callback is called when the value changes.
  final WalletPickerValueChanged? onChanged;

  /// Use this to override the default behavior of the selector.
  final PickWalletCallback? onPickWallet;
  final bool isTransfer;

  @override
  State<WalletSelector> createState() => _WalletSelectorState();
}

class _WalletSelectorState extends State<WalletSelector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _showHideTransferWalletAnimationController;
  late final Animation<Offset> _transferWalletOffsetAnimation;
  bool _isTransfer = false;

  @override
  void initState() {
    _isTransfer = widget.isTransfer;
    _showHideTransferWalletAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 210),
      reverseDuration: const Duration(milliseconds: 210),
    );
    _transferWalletOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _showHideTransferWalletAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WalletSelector oldWidget) {
    if (widget.isTransfer != _isTransfer) {
      setState(() {
        _isTransfer = widget.isTransfer;
      });
      _checkAndShowTransferWallet();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _checkAndShowTransferWallet() {
    if (_isTransfer) {
      _showHideTransferWalletAnimationController.forward();
    } else {
      _showHideTransferWalletAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallet = widget.wallet;
    final toWallet = widget.toWallet;
    final hasBothWallets = wallet != null && toWallet != null;

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _showHideTransferWalletAnimationController,
        builder: (context, child) {
          final isForwardOrCompletedOrAnimating =
              _showHideTransferWalletAnimationController.isCompleted ||
                  _showHideTransferWalletAnimationController.isAnimating;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(
                  alpha: _showHideTransferWalletAnimationController.isDismissed
                      ? 0
                      : 1,
                ),
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            padding: EdgeInsets.all(
              AppSpacing.lg * _showHideTransferWalletAnimationController.value,
            ),
            child: AnimatedSize(
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WalletItem(
                    wallet: wallet,
                    onTap: () {
                      if (widget.onPickWallet != null) {
                        widget.onPickWallet?.call(wallet, toWallet, true);
                      } else {
                        // TODO(tuanhm): implement this
                      }
                    },
                  ),
                  Visibility(
                    visible: isForwardOrCompletedOrAnimating,
                    maintainState: true,
                    child: Opacity(
                      opacity: _showHideTransferWalletAnimationController.value,
                      child: AnimatedBuilder(
                        animation: _transferWalletOffsetAnimation,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _transferWalletOffsetAnimation,
                            child: child,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                const SizedBox(width: AppSpacing.md),
                                IconButton.filled(
                                  onPressed: hasBothWallets ? _onSwap : null,
                                  icon: const Icon(Icons.swap_vert),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            _WalletItem(
                              wallet: toWallet,
                              onTap: () {
                                if (widget.onPickWallet != null) {
                                  widget.onPickWallet?.call(
                                    toWallet,
                                    wallet,
                                    false,
                                  );
                                } else {
                                  // TODO(tuanhm): Navigate to wallets picker
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSwap() {
    if (widget.wallet == null || widget.toWallet == null) {
      return;
    }
    final from = widget.wallet!;
    final to = widget.toWallet!;
    widget.onChanged?.call(to, from);
  }
}

class _WalletItem extends StatelessWidget {
  const _WalletItem({
    this.wallet,
    this.onTap,
  });

  final BaseWalletModel? wallet;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      tileColor: theme.colorScheme.surfaceContainerHigh,
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: wallet?.color,
        foregroundColor: wallet?.color.onContainer,
        child: wallet?.icon == null
            ? const Icon(Icons.wallet)
            : IconWidget(icon: wallet!.icon),
      ),
      title: Text(wallet?.name ?? 'Select a wallet'.hardCoded),
      subtitle: (wallet != null)
          ? Text(
              'Balance ${wallet!.balance.toCurrency(
                symbol: wallet!.currencyCode.symbol,
                locale: l10n.localeName,
              )}'
                  .hardCoded,
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
