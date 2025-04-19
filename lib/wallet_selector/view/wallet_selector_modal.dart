import 'package:app_ui/app_ui.dart';
import 'package:felicash/wallet/widgets/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_models/shared_models.dart';

class WalletSelectorModal extends StatelessWidget {
  const WalletSelectorModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const _WalletSelectorView();
  }
}

class _WalletSelectorView extends StatelessWidget {
  const _WalletSelectorView();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .6,
      minChildSize: .4,
      snapSizes: const [.6, .8],
      expand: false,
      snap: true,
      builder: (context, scrollController) {
        return ModalScaffold(
          header: Text('Select a wallet'.hardCoded),
          content: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.lg,
            ),
            child: Column(
              spacing: AppSpacing.lg,
              children: [
                const _SearchField(),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: AppSpacing.md);
                    },
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return WalletCard(
                        block: WalletBlock(
                          id: '',
                          name: 'Wallet $index',
                          color: Colors.blue,
                          balance: 1000000,
                          currency: 'USD',
                          icon: IconDataIcon(
                            raw: 'icon:${Icons.wallet.codePoint}',
                            icon: Icons.wallet,
                          ),
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

class _SearchField extends HookWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    return TextField(
      controller: textEditingController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
