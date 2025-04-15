import 'package:app_ui/app_ui.dart';
import 'package:felicash/transaction/bloc/transaction_creation_bloc.dart';
import 'package:felicash/transaction/widgets/transaction_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TransactionCreationModal extends StatelessWidget {
  const TransactionCreationModal({super.key, this.walletId});

  /// The target wallet id for the transaction.
  ///
  /// If not provided, the default wallet from setting will be used.
  final String? walletId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCreationBloc(
        walletRepository: context.read(),
      )..add(
          // TODO(tuanhm): Add default fallback target wallet if not provided
          TransactionCreationWalletChanged(id: walletId ?? ''),
        ),
      child: const _TransactionCreationView(),
    );
  }
}

class _TransactionCreationView extends HookWidget {
  const _TransactionCreationView();

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
                header: Text('New Transaction'.hardCoded),
                content: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: const TransactionCreationForm(),
                      ),
                    ),
                    const _AddTransactionButton(),
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
    // TODO(tuanhm): Check if form is dirty, and show confirmation dialog
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

class _AddTransactionButton extends StatelessWidget {
  const _AddTransactionButton();

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
        child: BlocSelector<TransactionCreationBloc, TransactionCreationState,
            bool>(
          selector: (state) => state.isValid,
          builder: (context, isValid) {
            return FilledButton(
              onPressed: isValid ? () => _createWallet(context) : null,
              child: Text('Add Transation'.hardCoded),
            );
          },
        ),
      ),
    );
  }

  void _createWallet(BuildContext context) {
    // context.read<WalletCreationBloc>().add(const WalletCreationSubmitted());
  }
}
