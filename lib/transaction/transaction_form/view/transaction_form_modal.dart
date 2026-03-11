import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/transaction/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:felicash/transaction/transaction_form/widgets/transaction_form.dart';
import 'package:felicash/transaction/transaction_list/bloc/transactions_bloc.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:felicash/wallet/cubit/wallets_filter_cubit.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:felicash/wallet/models/wallets_view_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/transaction_repository.dart';

class TransactionFormModal extends StatelessWidget {
  const TransactionFormModal({
    super.key,
    this.transaction,
    this.transactionId,
    this.walletId,
  });

  final TransactionModel? transaction;
  final String? transactionId;

  /// The target wallet id for the transaction.
  ///
  /// If not provided, the default wallet from setting will be used.
  final String? walletId;

  @override
  Widget build(BuildContext context) {
    final wallets = context.select<WalletsBloc, List<WalletViewModel>>((bloc) {
      return switch (bloc.state) {
        WalletLoadSuccess(:final wallets) => wallets,
        _ => [],
      };
    });
    return BlocProvider(
      create: (context) => WalletsFilterCubit()
        ..onFilterChanged(
          WalletsViewFilter(
            walletTypeEnum: WalletTypeEnum.values.first,
          ),
        ),
      child: BlocProvider(
        create: (context) {
          final bloc = TransactionFormBloc(
            transactionRepository: context.read(),
            walletRepository: context.read(),
            currencyRepository: context.read(),
          );
          if (walletId != null) {
            bloc.add(
              TransactionFormWalletChanged(
                id: walletId,
              ),
            );
          } else {
            bloc.add(
              TransactionFormWalletChanged(
                id: '',
                wallet: wallets.firstOrNull,
              ),
            );
          }
          return bloc
            ..add(
              TransactionFormInitialized(
                transaction: transaction,
                transactionId: transactionId,
              ),
            );
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<WalletsBloc, WalletsState>(
              listener: (context, state) {
                if (state is WalletLoadSuccess) {
                  context.read<TransactionFormBloc>().add(
                        TransactionFormWalletChanged(
                          wallet: state.wallets.firstOrNull,
                        ),
                      );
                }
              },
            ),
            BlocListener<TransactionFormBloc, TransactionFormState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == TransactionFormStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Transaction created'.hardCoded),
                    ),
                  );
                  context.pop();
                } else if (state.status == TransactionFormStatus.deleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Transaction deleted'.hardCoded),
                    ),
                  );
                  context.pop();
                }
              },
            ),
          ],
          child: const _TransactionCreationView(),
        ),
      ),
    );
  }
}

class _TransactionCreationView extends HookWidget {
  const _TransactionCreationView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                header: const _Header(),
                content: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: const TransactionForm(),
                      ),
                    ),
                    const _TransactionFormButtons(),
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
      builder: (context) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(l10n.transactionCreationModalAreYouSureText),
          content: Text(
            l10n.transactionCreationModalThisActionCannotBeUndoneText,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.transactionCreationModalCancelButtonText),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.transactionCreationModalYesButtonText),
            ),
          ],
        );
      },
    );

    if (confirm == null) return false;
    if (confirm && context.mounted) {
      Navigator.of(context).pop();
      return true;
    }

    return false;
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mode = context.select<TransactionFormBloc, TransactionMode>(
      (bloc) => bloc.state.mode,
    );
    final title = mode == TransactionMode.create
        ? l10n.transactionCreationModalTitle
        : 'Edit Transaction'.hardCoded; // TODO(dangddt): use l10n
    //l10n.transactionCreationModalEditTransactionTitle;
    return Text(
      title,
    );
  }
}

class _TransactionFormButtons extends StatelessWidget {
  const _TransactionFormButtons();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isValid = context.select<TransactionFormBloc, bool>((bloc) {
      return bloc.state.isValid;
    });

    final mode = context.select<TransactionFormBloc, TransactionMode>(
      (bloc) => bloc.state.mode,
    );
    final isDirty = context.select<TransactionFormBloc, bool>((bloc) {
      return bloc.state.isDirty;
    });
    final isLoading = context.select<TransactionFormBloc, bool>((bloc) {
      return bloc.state.status == TransactionFormStatus.loading ||
          bloc.state.status == TransactionFormStatus.submitting;
    });
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (mode == TransactionMode.edit) ...[
              IconButton(
                style: FilledButton.styleFrom(
                  minimumSize: AppIconButtonSizes.defaultMinimumSize,
                  maximumSize: AppIconButtonSizes.defaultMaximumSize,
                ),
                onPressed: () {
                  context
                      .read<TransactionFormBloc>()
                      .add(const TransactionFormDeleted());
                },
                icon: const Icon(Icons.delete),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Builder(
                builder: (context) {
                  final Widget child;
                  if (isLoading) {
                    child = const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    child = Text(
                      mode == TransactionMode.create
                          ? l10n
                              .transactionCreationModalAddTransactionButtonText
                          : 'Update'.hardCoded,
                    );
                  }
                  return FilledButton(
                    onPressed: isValid || isDirty
                        ? () {
                            context
                                .read<TransactionFormBloc>()
                                .add(const TransactionFormSubmitted());
                          }
                        : null,
                    child: child,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
