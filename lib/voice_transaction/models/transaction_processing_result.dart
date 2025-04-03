import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

enum TransactionProcessingStatus {
  initial,
  processing,
  completed,
  failed,
}

class TransactionProcessingResult extends Equatable {
  const TransactionProcessingResult({
    required this.source,
    required this.status,
    this.processingResult,
  });

  final String source;
  final TransactionProcessingStatus status;
  final ProcessingResult? processingResult;

  TransactionProcessingResult copyWith({
    String? source,
    TransactionProcessingStatus? status,
    ProcessingResult? processingResult,
  }) {
    return TransactionProcessingResult(
      source: source ?? this.source,
      status: status ?? this.status,
      processingResult: processingResult ?? this.processingResult,
    );
  }

  @override
  List<Object?> get props => [source, status, processingResult];
}

enum TransactionSavingStatus {
  saved,
  edited,
  deleted,
}

class ProcessingResult extends Equatable {
  const ProcessingResult({
    required this.responseText,
    this.status,
    this.transaction,
  });

  final String? responseText;
  final TransactionSavingStatus? status;
  final TransactionModel? transaction;

  ProcessingResult copyWith({
    String? responseText,
    TransactionSavingStatus? status,
    TransactionModel? transaction,
  }) {
    return ProcessingResult(
      responseText: responseText ?? this.responseText,
      status: status ?? this.status,
      transaction: transaction ?? this.transaction,
    );
  }

  @override
  List<Object?> get props => [transaction, responseText];
}
