import 'package:ai_client/src/models/post_extract_transaction_from_ocr_invoice_response.dart';
import 'package:ai_client/src/models/post_extract_transaction_from_text_response.dart';
import 'package:ai_client/src/requests/post_extract_transaction_from_ocr_invoice_body.dart';
import 'package:ai_client/src/requests/post_extract_transaction_from_text_body.dart';

abstract interface class AiClient {
  Future<List<PostExtractTransactionFromTextResponse>>
  postExtractTransactionFromText(PostExtractTransactionFromTextBody body) =>
      throw UnimplementedError();

  Future<List<PostExtractTransactionFromOCRInvoiceResponse>>
  postExtractTransactionFromOCRInvoice(
    PostExtractTransactionFromOCRInvoiceBody body,
  ) => throw UnimplementedError();
}
