import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/category/categories/bloc/categories_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CategoryListView();
  }
}

class _CategoryListView extends StatelessWidget {
  const _CategoryListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category List'),
      ),
      body: const _CategoriesListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRouteNames.categoryCreation);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CategoriesListView extends StatelessWidget {
  const _CategoriesListView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CategoriesBloc>().state;
    if (state is CategoriesInitial || state is CategoriesLoadInProgress) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is CategoriesLoadSuccess) {
      return const _CategoryList();
    }

    if (state is CategoriesLoadFailure) {
      return Center(
        child: Text('Failed to load categories: ${state.error}'.hardCoded),
      );
    }

    return const SizedBox.shrink();
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    final categories = context.select(
      (CategoriesBloc bloc) => (bloc.state as CategoriesLoadSuccess).categories,
    );
    if (categories.isEmpty) {
      return const Center(
        child: Text('No categories available.'),
      );
    }
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          title: Text(category.name),
          leading: const Icon(Icons.category),
          onTap: () {
            // Handle category tap
          },
        );
      },
    );
  }
}
