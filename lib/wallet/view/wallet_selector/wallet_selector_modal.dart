import 'package:app_ui/app_ui.dart';
import 'package:felicash/wallet/cubit/wallets_filter_cubit.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:felicash/wallet/models/wallets_view_filter.dart';
import 'package:felicash/wallet/widgets/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WalletSelectorModal extends StatelessWidget {
  const WalletSelectorModal({
    required this.wallets,
    super.key,
    this.title = 'Select a wallet',
    this.initialWallet,
  });

  final String title;
  final WalletViewModel? initialWallet;
  final List<WalletViewModel> wallets;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletsFilterCubit(),
      child: _WalletSelectorView(
        title: title,
        wallets: wallets,
        initialWallet: initialWallet,
      ),
    );
  }
}

class _WalletSelectorView extends HookWidget {
  const _WalletSelectorView({
    required this.title,
    required this.wallets,
    this.initialWallet,
  });

  final String title;
  final List<WalletViewModel> wallets;
  final WalletViewModel? initialWallet;

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final filter = context.select<WalletsFilterCubit, WalletsViewFilter>(
      (cubit) => cubit.state.filter,
    );
    final filteredWallets = filter.applyAll(wallets).toList();
    useEffect(
      () {
        void onSearch() {
          final query = searchController.text.toLowerCase();
          context.read<WalletsFilterCubit>().onFilterChanged(
                filter.copyWith(searchQuery: () => query),
              );
        }

        searchController.addListener(onSearch);
        return () => searchController.removeListener(onSearch);
      },
      [searchController],
    );
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .6,
      minChildSize: .4,
      snapSizes: const [.6, .8],
      expand: false,
      snap: true,
      builder: (context, scrollController) {
        return ModalScaffold(
          header: Text(title.hardCoded),
          content: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.lg,
            ),
            child: Column(
              spacing: AppSpacing.lg,
              children: [
                _SearchField(controller: searchController),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: AppSpacing.md);
                    },
                    itemCount: filteredWallets.length,
                    itemBuilder: (context, index) {
                      final wallet = filteredWallets[index];
                      final isSelected = wallet == initialWallet;
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pop(wallet);
                        },
                        child: WalletCard(
                          walletViewModel: wallet,
                          selected: isSelected,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        hintText: 'Search wallets',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
