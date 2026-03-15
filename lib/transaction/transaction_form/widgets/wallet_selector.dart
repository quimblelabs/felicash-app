import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:felicash/wallet/view/wallet_selector/wallet_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_models/shared_models.dart';

typedef WalletPickerValueChanged = void Function(
  WalletViewModel? from,
  WalletViewModel? to,
);

/// Creates a new [WalletSelector] for selecting a wallet.
typedef PickWalletCallback = void Function(
  WalletViewModel? current,
  WalletViewModel? otherWallet,
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
  final WalletViewModel? wallet;

  /// The current wallet to transfer to.
  final WalletViewModel? toWallet;

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
                    walletViewModel: wallet,
                    onTap: () => _onWalletItemTap(isFromWallet: true),
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
                              walletViewModel: toWallet,
                              onTap: () =>
                                  _onWalletItemTap(isFromWallet: false),
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

  Future<void> _onWalletItemTap({required bool isFromWallet}) async {
    final current = isFromWallet ? widget.wallet : widget.toWallet;
    final otherWallet = isFromWallet ? widget.toWallet : widget.wallet;

    if (widget.onPickWallet != null) {
      widget.onPickWallet?.call(current, otherWallet, isFromWallet);
      return;
    }

    final picked = await _showWalletSelectorModal(
      current: current,
      otherWallet: otherWallet,
    );

    if (!mounted || picked == null || picked == current) {
      return;
    }

    if (isFromWallet) {
      widget.onChanged?.call(picked, widget.toWallet);
    } else {
      widget.onChanged?.call(widget.wallet, picked);
    }
  }

  Future<WalletViewModel?> _showWalletSelectorModal({
    required WalletViewModel? current,
    required WalletViewModel? otherWallet,
  }) {
    final state = context.read<WalletsBloc>().state;
    if (state is! WalletLoadSuccess) {
      return Future.value();
    }

    final l10n = context.l10n;
    final wallets = state.wallets
        .where((wallet) => wallet.wallet.id != otherWallet?.wallet.id)
        .toList(growable: false);

    if (wallets.isEmpty) {
      return Future.value();
    }

    return showModalBottomSheet<WalletViewModel?>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => WalletSelectorModal(
        title: l10n.inputBoxSelectorModalTitle,
        wallets: wallets,
        initialWallet: current,
      ),
    );
  }
}

class _WalletItem extends StatelessWidget {
  const _WalletItem({
    required this.walletViewModel,
    this.onTap,
  });

  final WalletViewModel? walletViewModel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final wallet = walletViewModel?.wallet;
    final currency = walletViewModel?.currency;
    final balance = wallet?.balance.toCurrency(
      symbol: currency?.symbol,
      locale: l10n.localeName,
    );
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      tileColor: theme.colorScheme.surfaceContainerHigh,
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: wallet?.color,
        foregroundColor: wallet?.color.onContainer,
        child: IconWidget(
          icon: wallet?.icon ?? const IconDataIcon(raw: '', icon: Icons.wallet),
        ),
      ),
      title: Text(wallet?.name ?? l10n.unknown),
      subtitle: Text(l10n.walletSelectorBalanceText(balance ?? '0')),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
