import 'package:app_ui/app_ui.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CurrencySelectorModal extends StatelessWidget {
  const CurrencySelectorModal({
    required this.currencyPack,
    super.key,
    this.title = 'Select a currency',
    this.initialCurrency,
  });

  final String title;
  final CurrencyModel? initialCurrency;
  final List<CurrencyModel> currencyPack;

  @override
  Widget build(BuildContext context) {
    return _CurrencySelectorView(
      title: title,
      currencyPack: currencyPack,
      initialCurrency: initialCurrency,
    );
  }
}

class _CurrencySelectorView extends HookWidget {
  const _CurrencySelectorView({
    required this.title,
    required this.currencyPack,
    this.initialCurrency,
  });

  final String title;
  final List<CurrencyModel> currencyPack;
  final CurrencyModel? initialCurrency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchController = useTextEditingController();
    final filteredCurrencies = useState(currencyPack);

    useEffect(
      () {
        void filterCurrencies() {
          final query = searchController.text.toLowerCase();
          if (query.isEmpty) {
            filteredCurrencies.value = currencyPack;
          } else {
            filteredCurrencies.value = currencyPack.where((currency) {
              return currency.code.toLowerCase().contains(query) ||
                  currency.name.toLowerCase().contains(query) ||
                  currency.symbol.toLowerCase().contains(query);
            }).toList();
          }
        }

        searchController.addListener(filterCurrencies);
        return () => searchController.removeListener(filterCurrencies);
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
          header: Text(title),
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
                    itemCount: filteredCurrencies.value.length,
                    itemBuilder: (context, index) {
                      final currency = filteredCurrencies.value[index];
                      final isSelected = currency == initialCurrency;
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadius.lg,
                          ),
                        ),
                        tileColor: isSelected
                            ? theme.colorScheme.secondaryContainer
                                .withValues(alpha: .5)
                            : null,
                        leading: Text(
                          currency.symbol,
                          style: theme.textTheme.titleLarge,
                        ),
                        title: Text(currency.code),
                        subtitle: Text(currency.name),
                        trailing: isSelected ? const Icon(Icons.check) : null,
                        onTap: () {
                          Navigator.of(context).pop(currency);
                        },
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
        hintText: 'Search currencies',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
