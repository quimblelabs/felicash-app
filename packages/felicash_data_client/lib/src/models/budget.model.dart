import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/enums/budget_period.enum.dart';
import 'package:felicash_data_client/src/models/category.model.dart';
import 'package:felicash_data_client/src/models/profile.model.dart';
import 'package:uuid/uuid.dart';

/// {@template budget_model}
/// Budget model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'budgets'),
)
// ignore: must_be_immutable
class Budget extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro budget_model}
  Budget({
    required this.profile,
    required this.category,
    required this.period,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Id of the budget
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// User profile of the budget
  @Supabase(
    foreignKey: 'user_id',
    name: 'user_id',
    fromGenerator:
        'await ProfileAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.profile.id',
  )
  @Sqlite(onDeleteCascade: true)
  final Profile profile;

  /// Category id of the budget
  @Supabase(
    foreignKey: 'category_id',
    name: 'category_id',
    fromGenerator:
        'await CategoryAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.category.id',
  )
  @Sqlite(onDeleteCascade: true)
  final Category category;

  /// Period of the budget
  @Supabase(
    enumAsString: true,
    fromGenerator: 'BudgetPeriod.fromSupabase(%DATA_PROPERTY% as String)',
  )
  @Sqlite(enumAsString: true)
  final BudgetPeriod period;

  /// Amount of the budget
  final double amount;

  /// Start date of the budget
  final DateTime startDate;

  /// End date of the budget
  final DateTime endDate;

  /// Created at of the budget
  final DateTime createdAt;

  /// Updated at of the budget
  final DateTime updatedAt;

  /// User id of the budget
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String get userId => profile.id;

  /// Category id of the budget
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String get categoryId => category.id;

  @override
  List<Object?> get props => [
    id,
    profile,
    category,
    period,
    amount,
    startDate,
    endDate,
    createdAt,
    updatedAt,
  ];
}
