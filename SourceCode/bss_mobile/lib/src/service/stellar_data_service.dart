import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/http_client.dart';


class StellarDataService {
  final String _baseEndpoint = baseApiUrl;

  final size = Config.PAGE_SIZE;

  Future<dynamic> getStellarBalance() async {
    final response = await httpManager.get('$_baseEndpoint/api/stellar/account-inquiry', null);
    return response['data'];
  }

  Future<dynamic> payWithCYWStellar(transactionId) async {
    final response = await httpManager.post('$_baseEndpoint/api/stellar/payment/$transactionId', null);
    return response['data'];
  }
}
