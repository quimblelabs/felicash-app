import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TransactionListDateFilterView extends StatefulWidget {
  const TransactionListDateFilterView({
    required this.initialFrom,
    required this.initialTo,
    super.key,
  });

  final DateTime? initialFrom;
  final DateTime? initialTo;

  @override
  State<TransactionListDateFilterView> createState() =>
      _TransactionListDateFilterViewState();
}

class _TransactionListDateFilterViewState
    extends State<TransactionListDateFilterView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _selectedDay;
  PickerDateRange? _selectedRange;
  DateTime? _selectedMonth;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  int _getInitialTabIndex() {
    if (widget.initialFrom == null || widget.initialTo == null) {
      return 0; // Default to day tab if no initial dates
    }

    // Check if it's a single day
    if (widget.initialFrom!.year == widget.initialTo!.year &&
        widget.initialFrom!.month == widget.initialTo!.month &&
        widget.initialFrom!.day == widget.initialTo!.day) {
      return 0; // Day tab
    }

    // Check if it's a week (7 days)
    final difference = widget.initialTo!.difference(widget.initialFrom!).inDays;
    if (difference == 6 && widget.initialFrom!.weekday == 1) {
      return 1; // Week tab
    }

    // Check if it's a month
    if (widget.initialFrom!.day == 1 &&
        widget.initialTo!.day ==
            DateTime(widget.initialTo!.year, widget.initialTo!.month + 1, 0)
                .day) {
      return 2; // Month tab
    }

    // If none of the above, it's a custom range
    return 3; // Custom tab
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: _getInitialTabIndex(),
    );
    _selectedDay = widget.initialFrom;
    _selectedRange = widget.initialFrom != null && widget.initialTo != null
        ? PickerDateRange(widget.initialFrom, widget.initialTo)
        : null;
    _selectedMonth = widget.initialFrom;
    _customStartDate = widget.initialFrom;
    _customEndDate = widget.initialTo;
  }

  void _onSubmit() {
    if (_tabController.index == 0) {
      context.pop((_selectedDay, _selectedDay));
    } else if (_tabController.index == 1) {
      context.pop((_selectedRange?.startDate, _selectedRange?.endDate));
    } else if (_tabController.index == 2) {
      if (_selectedMonth != null) {
        final firstDay = DateTime(_selectedMonth!.year, _selectedMonth!.month);
        final lastDay =
            DateTime(_selectedMonth!.year, _selectedMonth!.month + 1, 0);
        context.pop((firstDay, lastDay));
      } else {
        context.pop((null, null));
      }
    } else if (_tabController.index == 3) {
      context.pop((_customStartDate, _customEndDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return SfDateRangePickerTheme(
      data: SfDateRangePickerThemeData(
        backgroundColor: theme.colorScheme.surface,
        headerBackgroundColor: theme.colorScheme.surface,
        todayHighlightColor: theme.colorScheme.primary,
        todayTextStyle: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        todayCellTextStyle: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      child: SheetContentScaffold(
        topBar: AppBar(
          title: Text(
            l10n.transactionListDateFilterViewTransactionDateAppBarTitle,
          ),
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
                _DateFilterTabBar(controller: _tabController),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _DayPickerView(
                        selectedDay: _selectedDay,
                        onDaySelected: (day) =>
                            setState(() => _selectedDay = day),
                      ),
                      _WeekPickerView(
                        selectedRange: _selectedRange,
                        onRangeSelected: (range) =>
                            setState(() => _selectedRange = range),
                      ),
                      _MonthPickerView(
                        selectedMonth: _selectedMonth,
                        onMonthSelected: (month) =>
                            setState(() => _selectedMonth = month),
                      ),
                      _CustomRangePickerView(
                        startDate: _customStartDate,
                        endDate: _customEndDate,
                        onStartDateChanged: (date) =>
                            setState(() => _customStartDate = date),
                        onEndDateChanged: (date) =>
                            setState(() => _customEndDate = date),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SubmitButton(
                  selectedDay: _selectedDay,
                  selectedRange: _selectedRange,
                  selectedMonth: _selectedMonth,
                  tabIndex: _tabController.index,
                  customStartDate: _customStartDate,
                  customEndDate: _customEndDate,
                  initialFrom: widget.initialFrom,
                  initialTo: widget.initialTo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateFilterTabBar extends StatelessWidget {
  const _DateFilterTabBar({
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return TabBar(
      controller: controller,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.black,
      labelStyle:
          theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      tabs: [
        Tab(text: l10n.day),
        Tab(text: l10n.week),
        Tab(text: l10n.month),
        Tab(text: l10n.custom),
      ],
    );
  }
}

class _DayPickerView extends StatelessWidget {
  const _DayPickerView({
    required this.selectedDay,
    required this.onDaySelected,
  });

  final DateTime? selectedDay;
  final ValueChanged<DateTime?> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      initialSelectedDate: selectedDay,
      monthViewSettings: const DateRangePickerMonthViewSettings(
        firstDayOfWeek: 1,
      ),
      onSelectionChanged: (args) => onDaySelected(args.value as DateTime?),
      showNavigationArrow: true,
      allowViewNavigation: false,
    );
  }
}

class _WeekPickerView extends StatefulWidget {
  const _WeekPickerView({
    required this.selectedRange,
    required this.onRangeSelected,
  });

  final PickerDateRange? selectedRange;
  final ValueChanged<PickerDateRange?> onRangeSelected;

  @override
  State<_WeekPickerView> createState() => _WeekPickerViewState();
}

class _WeekPickerViewState extends State<_WeekPickerView> {
  late DateRangePickerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DateRangePickerController();
  }

  void _selectionChanged(DateRangePickerSelectionChangedArgs args) {
    final ranges = args.value as PickerDateRange;
    if (ranges.startDate == null) return;

    var date1 = ranges.startDate!;
    var date2 = ranges.endDate ?? ranges.startDate!;

    if (date1.isAfter(date2)) {
      final temp = date1;
      date1 = date2;
      date2 = temp;
    }

    // Get the day of week (1 = Monday, 7 = Sunday)
    final dayOfWeek = date1.weekday;

    // Calculate days to subtract to get to Monday
    final daysToMonday = dayOfWeek - 1;

    // Calculate days to add to get to Sunday
    final daysToSunday = 7 - dayOfWeek;

    // Get the Monday of the selected week
    final monday = date1.subtract(Duration(days: daysToMonday));

    // Get the Sunday of the selected week
    final sunday = date1.add(Duration(days: daysToSunday));

    if (!_isSameDate(monday, ranges.startDate) ||
        !_isSameDate(sunday, ranges.endDate)) {
      _controller.selectedRange = PickerDateRange(monday, sunday);
      widget.onRangeSelected(PickerDateRange(monday, sunday));
    }
  }

  bool _isSameDate(DateTime date1, DateTime? date2) {
    if (date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      controller: _controller,
      selectionMode: DateRangePickerSelectionMode.range,
      initialSelectedRange: widget.selectedRange,
      monthViewSettings: const DateRangePickerMonthViewSettings(
        firstDayOfWeek: 1,
        enableSwipeSelection: false,
      ),
      onSelectionChanged: _selectionChanged,
      showNavigationArrow: true,
      allowViewNavigation: false,
    );
  }
}

class _MonthPickerView extends StatelessWidget {
  const _MonthPickerView({
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  final DateTime? selectedMonth;
  final ValueChanged<DateTime?> onMonthSelected;

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      view: DateRangePickerView.year,
      initialSelectedDate: selectedMonth,
      onSelectionChanged: (args) => onMonthSelected(args.value as DateTime?),
      showNavigationArrow: true,
      allowViewNavigation: false,
    );
  }
}

class _CustomRangePickerView extends StatelessWidget {
  const _CustomRangePickerView({
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final startDateString = startDate?.toString().split(' ')[0] ??
        l10n.transactionListDateFilterViewSelectDateButtonText;
    final endDateString = endDate?.toString().split(' ')[0] ??
        l10n.transactionListDateFilterViewSelectDateButtonText;
    return Column(
      children: [
        ListTile(
          title: Text(l10n.from),
          subtitle: Text(
            startDateString,
            style: theme.textTheme.bodyLarge,
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: startDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              onStartDateChanged(date);
            }
          },
        ),
        const Divider(),
        ListTile(
          title: Text(l10n.to),
          subtitle: Text(
            endDateString,
            style: theme.textTheme.bodyLarge,
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: endDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              onEndDateChanged(date);
            }
          },
        ),
      ],
    );
  }
}

class _SubmitButton extends HookWidget {
  const _SubmitButton({
    required this.selectedDay,
    required this.selectedRange,
    required this.selectedMonth,
    required this.tabIndex,
    required this.customStartDate,
    required this.customEndDate,
    required this.initialFrom,
    required this.initialTo,
  });

  final DateTime? selectedDay;
  final PickerDateRange? selectedRange;
  final DateTime? selectedMonth;
  final int tabIndex;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final DateTime? initialFrom;
  final DateTime? initialTo;

  bool _hasChanges() {
    if (tabIndex == 0) {
      return selectedDay != initialFrom;
    } else if (tabIndex == 1) {
      return selectedRange?.startDate != initialFrom ||
          selectedRange?.endDate != initialTo;
    } else if (tabIndex == 2) {
      if (selectedMonth == null) return initialFrom != null;
      final firstDay = DateTime(selectedMonth!.year, selectedMonth!.month);
      final lastDay =
          DateTime(selectedMonth!.year, selectedMonth!.month + 1, 0);
      return firstDay != initialFrom || lastDay != initialTo;
    } else if (tabIndex == 3) {
      return customStartDate != initialFrom || customEndDate != initialTo;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasChanges = _hasChanges();
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
      initialValue: hasChanges ? 1.0 : 0.0,
    );

    useEffect(
      () {
        if (hasChanges) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
        return null;
      },
      [hasChanges],
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              child: Text(
                l10n.transactionListDateFilterViewTodayCancelButtonText,
              ),
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
                    onPressed: () {
                      if (tabIndex == 0) {
                        context.pop((selectedDay, selectedDay));
                      } else if (tabIndex == 1) {
                        context.pop(
                          (selectedRange?.startDate, selectedRange?.endDate),
                        );
                      } else if (tabIndex == 2 && selectedMonth != null) {
                        final firstDay = DateTime(
                          selectedMonth!.year,
                          selectedMonth!.month,
                        );
                        final lastDay = DateTime(
                          selectedMonth!.year,
                          selectedMonth!.month + 1,
                          0,
                        );
                        context.pop((firstDay, lastDay));
                      } else if (tabIndex == 3) {
                        context.pop((customStartDate, customEndDate));
                      } else {
                        context.pop((null, null));
                      }
                    },
                    child: Text(
                      l10n.transactionListDateFilterViewTodayApplyButtonText,
                    ),
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
