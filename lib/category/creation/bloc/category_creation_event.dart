part of 'category_creation_bloc.dart';

sealed class CategoryCreationEvent extends Equatable {
  const CategoryCreationEvent();

  @override
  List<Object> get props => [];
}

class CategoryCreationNameChanged extends CategoryCreationEvent {
  const CategoryCreationNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class CategoryCreationDescriptionChanged extends CategoryCreationEvent {
  const CategoryCreationDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class CategoryCreationIconChanged extends CategoryCreationEvent {
  const CategoryCreationIconChanged(this.icon);

  final IconData icon;

  @override
  List<Object> get props => [icon];
}

class CategoryCreationColorChanged extends CategoryCreationEvent {
  const CategoryCreationColorChanged(this.color);

  final Color color;

  @override
  List<Object> get props => [color];
}

class CategoryCreationSubmitted extends CategoryCreationEvent {
  const CategoryCreationSubmitted();

  @override
  List<Object> get props => [];
}
