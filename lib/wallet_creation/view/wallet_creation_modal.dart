import 'package:app_ui/app_ui.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:felicash/currency/bloc/currencies_bloc.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/wallet_creation/bloc/wallet_creation_bloc.dart';
import 'package:felicash/wallet_creation/widgets/wallet_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/shared_models.dart';

extension on WalletTypeEnum {
  String name(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      WalletTypeEnum.basic => l10n.walletCreationModalBasicWalletTypeLabel,
      WalletTypeEnum.credit => l10n.walletCreationModalCreditWalletTypeLabel,
      WalletTypeEnum.savings => l10n.walletCreationModalSavingsWalletTypeLabel,
    };
  }
}

class WalletCreationModal extends StatelessWidget {
  const WalletCreationModal({required this.walletType, super.key});

  final WalletTypeEnum walletType;

  @override
  Widget build(BuildContext context) {
    final secondaryFixed = Theme.of(context).colorScheme.secondaryFixed;
    final currencies = context.select<CurrenciesBloc, List<CurrencyModel>>(
      (bloc) => switch (bloc.state) {
        CurrenciesLoadSuccess(:final currencies) => currencies,
        _ => [],
      },
    );
    return BlocProvider(
      create: (context) {
        final currency = currencies.firstOrNull;
        final bloc = WalletCreationBloc(
          walletRepository: context.read(),
          walletType: walletType,
          color: secondaryFixed,
        );
        if (currency != null) {
          bloc.add(WalletCreationCurrencyChanged(currency));
        }
        return bloc;
      },
      child: BlocListener<WalletCreationBloc, WalletCreationState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          final l10n = context.l10n;
          // Check if WalletCreationState is successful created a
          // wallet and get back true
          if (state.status == WalletCreationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.walletCreationModalWalletCreatedSuccessfullyText,
                ),
              ),
            );
            context.pop();
          } else if (state.status == WalletCreationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? l10n.unknownError),
              ),
            );
          }
        },
        child: const _WalletCreationView(),
      ),
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
    final l10n = context.l10n;
    // TODO(tuanhm): Check if form is dirty, and show confirmation dialog
    final confirm = await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.walletCreationModalAreYouSureText),
        content: Text(l10n.walletCreationModalThisActionCannotBeUndoneText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.walletCreationModalCancelButtonText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.walletCreationModalYesButtonText),
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
    final l10n = context.l10n;
    final walletType = context.read<WalletCreationBloc>().state.walletType;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Text(
        l10n.walletCreationModalCreateWithWalletTypeText(
          walletType.name(context),
        ),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class _CreateWalletButton extends StatelessWidget {
  const _CreateWalletButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              child: Text(l10n.walletCreationModalCreateWalletButtonText),
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
