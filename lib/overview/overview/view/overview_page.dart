import 'package:app_ui/app_ui.dart';
import 'package:felicash/overview/overview/widgets/overview_app_bar.dart';
import 'package:felicash/overview/spending_by_category/bloc/spending_by_category_bloc.dart';
import 'package:felicash/overview/spending_by_category/view/spending_by_category_section.dart';
import 'package:felicash/overview/summary_trending/bloc/summary_trending_section_bloc.dart';
import 'package:felicash/overview/summary_trending/view/summary_trending_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SummaryTrendingSectionBloc()
            ..add(SummaryTrendingSectionSubscriptionRequested()),
        ),
        BlocProvider(
          create: (_) => SpendingByCategoryBloc(
            transactionRepository: context.read(),
          )..add(SpendingByCategorySubscriptionRequested()),
        ),
      ],
      child: const _OverviewView(),
    );
  }
}

class _OverviewView extends StatelessWidget {
  const _OverviewView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CardTheme(
      color: theme.colorScheme.surfaceContainerLowest,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xlg),
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainer,
        body: CustomScrollView(
          slivers: [
            // const OverviewAppBar(),
            const OverviewAppBar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              sliver: SliverList.list(
                children: const [
                  SummaryTrendingSection(),
                  SizedBox(height: AppSpacing.lg),
                  SpendingByCategorySection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
