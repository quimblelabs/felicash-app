import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';

enum AiProcessingStatus {
  initial,
  processing,
  completed,
  failed;

  bool get isInitial => this == initial;
  bool get isProcessing => this == processing;
  bool get isCompleted => this == completed;
  bool get isFailed => this == failed;
}

class AiAssistantRequestModel extends Equatable {
  AiAssistantRequestModel({
    required this.source,
    required this.status,
    this.response,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Creates a new [AiAssistantRequestModel] from a [String].
  factory AiAssistantRequestModel.fromText(String source) {
    return AiAssistantRequestModel(
      source: source,
      status: AiProcessingStatus.initial,
    );
  }
  final String id;
  final String source;
  final AiProcessingStatus status;
  final ProcessingResponse? response;

  AiAssistantRequestModel copyWith({
    String? id,
    String? source,
    AiProcessingStatus? status,
    ProcessingResponse? response,
  }) {
    return AiAssistantRequestModel(
      id: id ?? this.id,
      source: source ?? this.source,
      status: status ?? this.status,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [id, source, status, response];
}

class ProcessingResponse extends Equatable {
  const ProcessingResponse({
    required this.responseText,
    this.transactions = const [],
  });

  final String responseText;
  final List<TransactionModel> transactions;

  ProcessingResponse copyWith({
    String? responseText,
    List<TransactionModel>? transactions,
  }) {
    return ProcessingResponse(
      responseText: responseText ?? this.responseText,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [transactions, responseText];
}
