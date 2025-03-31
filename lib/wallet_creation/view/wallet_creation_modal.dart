import 'package:app_ui/app_ui.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:felicash/wallet_creation/bloc/wallet_creation_bloc.dart';
import 'package:felicash/wallet_creation/widgets/wallet_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet_repository/wallet_repository.dart' show WalletTypeEnum;

class WalletCreationModal extends StatelessWidget {
  const WalletCreationModal({required this.walletType, super.key});

  final WalletTypeEnum walletType;

  @override
  Widget build(BuildContext context) {
    final secondaryFixed = Theme.of(context).colorScheme.secondaryFixed;
    return BlocProvider(
      create: (context) => WalletCreationBloc(
        walletType: walletType,
        //TODO: Change to the current user currency
        currency: CurrencyModel(
          code: 'USD',
          name: 'United States Dollar',
          symbol: r'$',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        color: secondaryFixed,
      ),
      child: const _WalletCreationView(),
    );
  }
}

class _WalletCreationView extends HookWidget {
  const _WalletCreationView();

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.of(context).viewInsets;
    final draggableScrollableController = useDraggableScrollableController();
    final isAnimatingBack = useState(false);
    useEffect(
      () {
        Future<void> onScroll() async {
          if (draggableScrollableController.size <= .9 &&
              !isAnimatingBack.value) {
            isAnimatingBack.value = true;
            final isPop = await _checkAndShowPopConfirmation(context);
            if (!isPop) {
              await draggableScrollableController.animateTo(
                .9,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              );
              isAnimatingBack.value = false;
            }
          }
        }

        draggableScrollableController.addListener(onScroll);

        return () {
          draggableScrollableController.removeListener(onScroll);
        };
      },
      [draggableScrollableController],
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _checkAndShowPopConfirmation(context);
        }
        return;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DraggableScrollableSheet(
          controller: draggableScrollableController,
          initialChildSize: .9,
          minChildSize: .85,
          snapSizes: const [.9, 1],
          expand: false,
          snap: true,
          shouldCloseOnMinExtent: false,
          builder: (context, controller) {
            return Padding(
              padding: EdgeInsets.only(bottom: viewPadding.bottom),
              child: ModalScaffold(
                header: const _Title(),
                content: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: const WalletCreationForm(),
                      ),
                    ),
                    const _CreateWalletButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _checkAndShowPopConfirmation(BuildContext context) async {
    // TODO: Check if form is dirty, and show confirmation dialog
    final confirm = await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'.hardCoded),
        content: Text('This action cannot be undone.'.hardCoded),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'.hardCoded),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'.hardCoded),
          ),
        ],
      ),
    );

    if (confirm == null) return false;
    if (confirm && context.mounted) {
      Navigator.of(context).pop();
      return true;
    }

    return false;
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final walletType = context.read<WalletCreationBloc>().state.walletType;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Text(
        'Create ${walletType.name} wallet'.hardCoded,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class _CreateWalletButton extends StatelessWidget {
  const _CreateWalletButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: BlocSelector<WalletCreationBloc, WalletCreationState, bool>(
          selector: (state) => state.isValid,
          builder: (context, isValid) {
            return FilledButton(
              onPressed: isValid ? () => _createWallet(context) : null,
              child: Text('Create wallet'.hardCoded),
            );
          },
        ),
      ),
    );
  }

  void _createWallet(BuildContext context) {
    context.read<WalletCreationBloc>().add(const WalletCreationSubmitted());
  }
}
