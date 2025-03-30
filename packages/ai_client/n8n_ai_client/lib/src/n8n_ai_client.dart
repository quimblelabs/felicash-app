import 'package:ai_client/ai_client.dart';
import 'package:ai_client/src/models/post_extract_transaction_from_ocr_invoice_response.dart';
import 'package:ai_client/src/requests/post_extract_transaction_from_ocr_invoice_body.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'n8n_ai_client.g.dart';

@RestApi()
abstract class N8nAiClient implements AiClient {
  factory N8nAiClient(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _N8nAiClient;

  @POST('/extract-transaction-from-text')
  @override
  Future<List<PostExtractTransactionFromTextResponse>>
  postExtractTransactionFromText(
    @Body() PostExtractTransactionFromTextBody body,
  );

  @POST('/extract-transaction-from-ocr-invoice')
  @override
  Future<List<PostExtractTransactionFromOCRInvoiceResponse>>
  postExtractTransactionFromOCRInvoice(
    @Body() PostExtractTransactionFromOCRInvoiceBody body,
  );
}
