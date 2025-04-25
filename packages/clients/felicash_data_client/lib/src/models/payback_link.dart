import 'package:felicash_data_client/src/models/transaction.dart';
import 'package:felicash_data_client/src/typedefs/typedef.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payback_link.g.dart';

/// {@template payback_link_fields}
/// Payback link fields
/// {@endtemplate}
typedef PaybackLinkFields = _$PaybackLinkJsonKeys;

/// {@template savings_wallet_model}
/// Payback link model
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class PaybackLink {
  /// {@macro payback_link_model}
  const PaybackLink({
    required this.paybackLinkId,
    required this.paybackLinkCreatedAt,
    required this.paybackLinkOriginalTransactionId,
    required this.paybackLinkPaybackTransactionId,
    this.paybackLinkOriginalTransactions = const [],
    this.paybackLinkPaybackTransactions = const [],
  }) : id = paybackLinkId;

  /// Factory constructor for [PaybackLink] from [SqliteRow]
  factory PaybackLink.fromRow(SqliteRow row) {
    return PaybackLink(
      paybackLinkId: row[PaybackLinkFields.paybackLinkId] as String,
      paybackLinkCreatedAt: DateTime.parse(
        row[PaybackLinkFields.paybackLinkCreatedAt] as String,
      ),
      paybackLinkOriginalTransactionId:
          row[PaybackLinkFields.paybackLinkOriginalTransactionId] as String,
      paybackLinkPaybackTransactionId:
          row[PaybackLinkFields.paybackLinkPaybackTransactionId] as String,
      paybackLinkOriginalTransactions: [],
      paybackLinkPaybackTransactions: [],
    );
  }

  /// Table name of the payback link
  static const String tableName = 'payback_links';

  /// Id field to suitable with sqlite database
  final String id;

  /// Unique identifier for the payback link
  final String paybackLinkId;

  /// The date and time when the payback link was created
  final DateTime paybackLinkCreatedAt;

  /// Payback link original transaction id of the payback link
  final String paybackLinkOriginalTransactionId;

  /// Transaction of the payback link
  final List<Transaction> paybackLinkOriginalTransactions;

  /// Payback link payback transaction id of the payback link
  final String paybackLinkPaybackTransactionId;

  /// Payback transaction of the payback link
  final List<Transaction> paybackLinkPaybackTransactions;

  /// Creates a copy of this [PaybackLink] but with the given fields
  PaybackLink copyWith({
    String? paybackLinkId,
    DateTime? paybackLinkCreatedAt,
    String? paybackLinkOriginalTransactionId,
    String? paybackLinkPaybackTransactionId,
    List<Transaction>? paybackLinkOriginalTransactions,
    List<Transaction>? paybackLinkPaybackTransactions,
  }) {
    return PaybackLink(
      paybackLinkId: paybackLinkId ?? this.paybackLinkId,
      paybackLinkCreatedAt: paybackLinkCreatedAt ?? this.paybackLinkCreatedAt,
      paybackLinkOriginalTransactionId:
          paybackLinkOriginalTransactionId ??
          this.paybackLinkOriginalTransactionId,
      paybackLinkPaybackTransactionId:
          paybackLinkPaybackTransactionId ??
          this.paybackLinkPaybackTransactionId,
      paybackLinkOriginalTransactions:
          paybackLinkOriginalTransactions ??
          this.paybackLinkOriginalTransactions,
      paybackLinkPaybackTransactions:
          paybackLinkPaybackTransactions ?? this.paybackLinkPaybackTransactions,
    );
  }
}
