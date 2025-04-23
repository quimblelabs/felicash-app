import 'package:flutter/material.dart';

class CategoriesFilterView extends StatelessWidget {
  const CategoriesFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Categories'),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => Text('Category $index'),
          ),
        ),
      ],
    );
  }
}
