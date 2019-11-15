import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/models/bloc_delegate.dart';
import 'package:bss_mobile/src/models/wallet_model.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:rxdart/rxdart.dart';

class WalletBloc extends BlocBase {
  final DataService dataService = DataService();
  BlocDelegate<dynamic> delegate;

  final _walletList = BehaviorSubject<Wallet>();

  // Stream
  Observable<Wallet> get walletList => _walletList.stream;

  // WalletBloc() {}
  WalletBloc({this.delegate});

  addOffersToWallet(offerIds) async {
    try {
      final response = await dataService.addOffersToWallet(offerIds);
      this.delegate.success(response);
    } catch (error) {
      this.delegate.error(error);
    }
  }

  //redeem at table
  redeemAtTable(offerIds, qrcode) async {
    return dataService.redeemAtTable(offerIds, qrcode);
  }

  @override
  void dispose() {
    _walletList.close();
  }
}
