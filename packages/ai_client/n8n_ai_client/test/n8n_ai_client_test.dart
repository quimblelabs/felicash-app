import 'package:ai_client/ai_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:n8n_ai_client/src/n8n_ai_client.dart';

import '_keys.dart';

void main() {
  late Dio dio;

  setUpAll(() async {
    dio = Dio(
      BaseOptions(headers: {'Authorization': 'Bearer ${Keys.ACCESS_TOKEN}'}),
    );
  });
  group('Transaction Extraction API Tests', () {
    test('Post extract transaction from text successfully', () async {
      final client = N8nAiClient(dio, baseUrl: Keys.BASE_URL);
      final response = await client.postExtractTransactionFromText(
        PostExtractTransactionFromTextBody(
          queryText:
              'Hôm nay, lúc 15h tôi có ăn một tô hủ tiếu hết 40k tại tiệm hủ tiếu Thiên Kim, hủ tiếu khá là ngon á nha',
          knowledgeBase: KnowledgeBaseBody(
            categories: [
              CategoryKnowledgeBaseBody(
                id: '751b0c10-d10e-472b-b953-d7463fecb819',
                name: 'Ăn uống',
                description: 'Các giao dịch chi trả cho việc ăn uống.',
              ),
              CategoryKnowledgeBaseBody(
                id: '5346a559-7eab-4682-90da-ee8e510784d1',
                name: 'Mua sắm',
                description: 'Các giao dịch chi trả cho việc mua sắm.',
              ),
            ],
            transactionTypes: [
              "income",
              "re_payment",
              "lending",
              "borrowing",
              "expense",
              "debt_collecting",
              "transfer",
            ],
            wallets: [
              WalletKnowledgeBaseBody(
                id: '0df79f43-efc2-42f7-8277-611bb752eba0',
                name: 'Ví tiền mặt',
                description:
                    'Ví dùng cho các chi tiêu và thu nhập bằng tiền mặt',
              ),
              WalletKnowledgeBaseBody(
                id: 'd88fe0bd-a91d-499a-898c-395e7e5c0c50',
                name: 'Ví tiết kiệm',
                description: 'Ví chứa các khoản tiết kiệm của tôi',
              ),
            ],
          ),
        ),
      );
      expect(response, isNotNull);
    });

    test('Post extract transaction from OCR invoice successfully', () async {
      final client = N8nAiClient(dio, baseUrl: Keys.BASE_URL);
      final response = await client.postExtractTransactionFromOCRInvoice(
        PostExtractTransactionFromOCRInvoiceBody(
          queryText:
              'https://groehwecbeoipralpjlw.supabase.co/storage/v1/object/public/test//hoa-don-bhx-16270145993242051865174.webp',
          knowledgeBase: KnowledgeBaseBody(
            categories: [
              CategoryKnowledgeBaseBody(
                id: '751b0c10-d10e-472b-b953-d7463fecb819',
                name: 'Ăn uống',
                description: 'Các giao dịch chi trả cho việc ăn uống.',
              ),
              CategoryKnowledgeBaseBody(
                id: '5346a559-7eab-4682-90da-ee8e510784d1',
                name: 'Mua sắm',
                description: 'Các giao dịch chi trả cho việc mua sắm.',
              ),
            ],
            transactionTypes: [
              "income",
              "re_payment",
              "lending",
              "borrowing",
              "expense",
              "debt_collecting",
              "transfer",
            ],
            wallets: [
              WalletKnowledgeBaseBody(
                id: '0df79f43-efc2-42f7-8277-611bb752eba0',
                name: 'Ví tiền mặt',
                description:
                    'Ví dùng cho các chi tiêu và thu nhập bằng tiền mặt',
              ),
              WalletKnowledgeBaseBody(
                id: 'd88fe0bd-a91d-499a-898c-395e7e5c0c50',
                name: 'Ví tiết kiệm',
                description: 'Ví chứa các khoản tiết kiệm của tôi',
              ),
            ],
          ),
        ),
      );
      expect(response, isNotNull);
    });
  });
}


// {
//     "query_text": "Hôm nay, lúc 15h tôi có ăn một tô hủ tiếu hết 40k tại tiệm hủ tiếu Thiên Kim, hủ tiếu khá là ngon á nha",
//     "knowledge_base": {
//         "categories": [
//             {
//                 "id": "751b0c10-d10e-472b-b953-d7463fecb819",
//                 "name": "Ăn uống",
//                 "description": "Các giao dịch chi trả cho việc ăn uống."
//             },
//             {
//                 "id": "5346a559-7eab-4682-90da-ee8e510784d1",
//                 "name": "Mua sắm",
//                 "description": "Các giao dịch liên quan đến mua sắm, shopping,..."
//             }
//         ],
//         "transaction_types": [
//             "income",
//             "re_payment",
//             "lending",
//             "borrowing",
//             "expense",
//             "debt_collecting",
//             "transfer"
//         ],
//         "wallets": [
//             {
//                 "id": "0df79f43-efc2-42f7-8277-611bb752eba0",
//                 "name": "Ví tiền mặt",
//                 "description": "Ví dùng cho các chi tiêu và thu nhập bằng tiền mặt"
//             },
//             {
//                 "id": "d88fe0bd-a91d-499a-898c-395e7e5c0c50",
//                 "name": "Ví tiết kiệm",
//                 "description": "Ví chứa các khoản tiết kiệm của tôi"
//             }
//         ]
//     }
// }