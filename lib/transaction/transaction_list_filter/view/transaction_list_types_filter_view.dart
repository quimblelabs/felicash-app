import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/shared_models.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TransactionListTypesFilterView extends StatefulWidget {
  const TransactionListTypesFilterView({
    required this.initialSelected,
    super.key,
  });

  final Set<TransactionTypeEnum> initialSelected;

  @override
  State<TransactionListTypesFilterView> createState() =>
      _TransactionListTypesFilterViewState();
}

class _TransactionListTypesFilterViewState
    extends State<TransactionListTypesFilterView> {
  late Set<TransactionTypeEnum> _selectedTypes;

  @override
  void initState() {
    super.initState();
    _selectedTypes = {...widget.initialSelected};
  }

  void _onTypeSelected(TransactionTypeEnum type, bool? value) {
    setState(() {
      final isSelected = value ?? false;
      final newSelectedTypes = Set<TransactionTypeEnum>.from(_selectedTypes);
      if (!isSelected) {
        newSelectedTypes.remove(type);
      } else {
        newSelectedTypes.add(type);
      }
      _selectedTypes = newSelectedTypes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final types = TransactionTypeEnum.availableValues;
    final canSelectAll =
        types.isNotEmpty && _selectedTypes.length < types.length;
    final canDeselectAll = types.isNotEmpty && _selectedTypes.isNotEmpty;
    return SheetContentScaffold(
      topBar: AppBar(
        title: Text('Transaction Types'.hardCoded),
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
              const SizedBox(height: AppSpacing.md),
              _SelectionsToggle(
                selectedTypes: _selectedTypes,
                onSelectedAll: canSelectAll
                    ? () {
                        setState(() {
                          _selectedTypes = Set<TransactionTypeEnum>.from(types);
                        });
                      }
                    : null,
                onDeselectedAll: canDeselectAll
                    ? () {
                        setState(() {
                          _selectedTypes = {};
                        });
                      }
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 500),
                child: _TypeList(
                  types: types,
                  selectedTypes: _selectedTypes,
                  onTypeSelected: _onTypeSelected,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SubmitButton(
                selectedTypes: _selectedTypes,
                initialSelected: widget.initialSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionsToggle extends StatelessWidget {
  const _SelectionsToggle({
    required this.selectedTypes,
    required this.onSelectedAll,
    required this.onDeselectedAll,
  });

  final Set<TransactionTypeEnum> selectedTypes;
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

class _TypeList extends StatelessWidget {
  const _TypeList({
    required this.types,
    required this.selectedTypes,
    required this.onTypeSelected,
  });

  final List<TransactionTypeEnum> types;
  final Set<TransactionTypeEnum> selectedTypes;
  final void Function(TransactionTypeEnum, bool?) onTypeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (types.isEmpty) {
      return Center(
        child: Text(
          'No types found'.hardCoded,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.hintColor,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        return _TypeItem(
          type: type,
          isSelected: selectedTypes.contains(type),
          onSelected: (value) => onTypeSelected(type, value),
        );
      },
    );
  }
}

class _TypeItem extends StatelessWidget {
  const _TypeItem({
    required this.type,
    required this.isSelected,
    required this.onSelected,
  });

  final TransactionTypeEnum type;
  final bool isSelected;
  final ValueChanged<bool?> onSelected;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      value: isSelected,
      onChanged: onSelected,
      title: Text(type.name),
      controlAffinity: ListTileControlAffinity.leading,
      secondary: Icon(type.icon),
    );
  }
}

class _SubmitButton extends HookWidget {
  const _SubmitButton({
    required this.selectedTypes,
    required this.initialSelected,
  });

  final Set<TransactionTypeEnum> selectedTypes;
  final Set<TransactionTypeEnum> initialSelected;

  bool _hasChanges() {
    return !initialSelected.isSameOfAll(selectedTypes);
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
                    onPressed: () => context.pop(selectedTypes),
                    child: Text('Update (${selectedTypes.length})'.hardCoded),
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

extension on Set<TransactionTypeEnum> {
  /// Returns true if the set contains all the elements of the other
  /// set and vice versa, also length must be the same.
  bool isSameOfAll(Set<TransactionTypeEnum> other) {
    if (length != other.length) {
      return false;
    }
    if (isEmpty) {
      return other.isEmpty;
    }
    return other.every(contains) && every(other.contains);
  }
}
