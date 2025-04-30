import 'package:app_ui/app_ui.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class TransactionListWalletsFilerView extends StatefulWidget {
  const TransactionListWalletsFilerView({
    required this.initialSelected,
    super.key,
  });

  final Set<WalletViewModel> initialSelected;

  @override
  State<TransactionListWalletsFilerView> createState() =>
      _TransactionListWalletsFilerViewState();
}

class _TransactionListWalletsFilerViewState
    extends State<TransactionListWalletsFilerView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  late Set<WalletViewModel> _selectedWallets;

  @override
  void initState() {
    super.initState();
    _selectedWallets = {...widget.initialSelected};
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchTextChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  void _onWalletSelected(WalletViewModel wallet, bool? value) {
    setState(() {
      final isSelected = value ?? false;
      final newSelectedWallets = Set<WalletViewModel>.from(_selectedWallets);
      if (!isSelected) {
        newSelectedWallets.remove(wallet);
      } else {
        newSelectedWallets.add(wallet);
      }
      _selectedWallets = newSelectedWallets;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletsState = context.select<WalletsBloc, WalletsState>(
      (value) => value.state,
    );

    if (walletsState is WalletLoadFailure) {
      return Center(
        child: Text('Failed to load wallets'.hardCoded),
      );
    }

    if (walletsState is WalletLoadInProgress || walletsState is WalletInitial) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final wallets = (walletsState as WalletLoadSuccess)
        .wallets
        .where(
          (wallet) => wallet.wallet.name
              .toLowerCase()
              .contains(_searchText.toLowerCase()),
        )
        .toList();
    final canSelectAll =
        wallets.isNotEmpty && _selectedWallets.length < wallets.length;
    final canDeselectAll = wallets.isNotEmpty && _selectedWallets.isNotEmpty;
    return SheetContentScaffold(
      topBar: AppBar(
        title: Text('Transaction Wallets'.hardCoded),
      ),
      body: Material(
        color: theme.colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WalletSearchField(controller: _searchController),
              const SizedBox(height: AppSpacing.md),
              _SelectionsToggle(
                selectedWallets: _selectedWallets,
                onSelectedAll: canSelectAll
                    ? () {
                        setState(() {
                          _selectedWallets = Set<WalletViewModel>.from(wallets);
                        });
                      }
                    : null,
                onDeselectedAll: canDeselectAll
                    ? () {
                        setState(() {
                          _selectedWallets = {};
                        });
                      }
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 500),
                child: _WalletList(
                  wallets: wallets,
                  selectedWallets: _selectedWallets,
                  onWalletSelected: _onWalletSelected,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SubmitButton(
                selectedWallets: _selectedWallets,
                initialSelected: widget.initialSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletSearchField extends StatelessWidget {
  const _WalletSearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Search wallets',
        isDense: true,
        prefixIcon: Icon(Icons.search),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}

class _SelectionsToggle extends StatelessWidget {
  const _SelectionsToggle({
    required this.selectedWallets,
    required this.onSelectedAll,
    required this.onDeselectedAll,
  });

  final Set<WalletViewModel> selectedWallets;
  final VoidCallback? onSelectedAll;
  final VoidCallback? onDeselectedAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onSelectedAll,
          child: const Text('Select all'),
        ),
        TextButton(
          onPressed: onDeselectedAll,
          child: const Text('Deselect all'),
        ),
      ],
    );
  }
}

class _WalletList extends StatelessWidget {
  const _WalletList({
    required this.wallets,
    required this.selectedWallets,
    required this.onWalletSelected,
  });

  final List<WalletViewModel> wallets;
  final Set<WalletViewModel> selectedWallets;
  final void Function(WalletViewModel, bool?) onWalletSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (wallets.isEmpty) {
      return Center(
        child: Text(
          'No wallets found'.hardCoded,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.hintColor,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: wallets.length,
      itemBuilder: (context, index) {
        final wallet = wallets[index];
        return _WalletItem(
          wallet: wallet,
          isSelected: selectedWallets.contains(wallet),
          onSelected: (value) => onWalletSelected(wallet, value),
        );
      },
    );
  }
}

class _WalletItem extends StatelessWidget {
  const _WalletItem({
    required this.wallet,
    required this.isSelected,
    required this.onSelected,
  });

  final WalletViewModel wallet;
  final bool isSelected;
  final ValueChanged<bool?> onSelected;

  @override
  Widget build(BuildContext context) {
    final wallet = this.wallet.wallet;
    return CheckboxListTile(
      dense: true,
      value: isSelected,
      onChanged: onSelected,
      title: Text(wallet.name),
      controlAffinity: ListTileControlAffinity.leading,
      secondary: CircleAvatar(
        backgroundColor: wallet.color.withAlpha(100),
        foregroundColor: wallet.color,
        child: IconWidget(icon: wallet.icon),
      ),
    );
  }
}

class _SubmitButton extends HookWidget {
  const _SubmitButton({
    required this.selectedWallets,
    required this.initialSelected,
  });

  final Set<WalletViewModel> selectedWallets;
  final Set<WalletViewModel> initialSelected;

  bool _hasChanges() {
    return !initialSelected.isSameOfAll(selectedWallets);
  }

  @override
  Widget build(BuildContext context) {
    final hasChanges = _hasChanges();
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
      initialValue: hasChanges ? 1.0 : 0.0,
    );

    useEffect(() {
      if (hasChanges) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [hasChanges]);

    final slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              child: Text('Cancel'.hardCoded),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: hasChanges ? 1 : 0,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                width: hasChanges ? null : 0,
                child: SlideTransition(
                  position: slideAnimation,
                  child: FilledButton(
                    onPressed: () => context.pop(selectedWallets),
                    child: Text('Update (${selectedWallets.length})'.hardCoded),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on Set<WalletViewModel> {
  /// Returns true if the set contains all the elements of the other
  /// set and vice versa, also length must be the same.
  bool isSameOfAll(Set<WalletViewModel> other) {
    if (length != other.length) {
      return false;
    }
    if (isEmpty) {
      return other.isEmpty;
    }
    return other.every(contains) && every(other.contains);
  }
}
