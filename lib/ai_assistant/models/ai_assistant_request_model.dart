import 'package:equatable/equatable.dart';
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
    required this.text,
    required this.status,
    this.response,
    this.attachments = const [],
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Creates a new [AiAssistantRequestModel] from a [String].
  factory AiAssistantRequestModel.fromText(String source) {
    return AiAssistantRequestModel(
      text: source,
      status: AiProcessingStatus.initial,
    );
  }

  /// Creates a new [AiAssistantRequestModel] from a list of attachments.
  /// This is used when the user selects a file from the file picker.
  factory AiAssistantRequestModel.fromAttachments(List<String> attachments) {
    return AiAssistantRequestModel(
      text: '',
      status: AiProcessingStatus.initial,
      attachments: attachments,
    );
  }

  final String id;
  final List<String> attachments;
  final String text;
  final AiProcessingStatus status;
  final ProcessingResponse? response;

  AiAssistantRequestModel copyWith({
    String? id,
    String? source,
    List<String>? attachments,
    AiProcessingStatus? status,
    ProcessingResponse? response,
  }) {
    return AiAssistantRequestModel(
      id: id ?? this.id,
      text: source ?? text,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [id, text, attachments, status, response];
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
