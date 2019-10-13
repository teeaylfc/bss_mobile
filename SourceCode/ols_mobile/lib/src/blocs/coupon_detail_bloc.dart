import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/models/item_detail_model.dart';
import 'package:ols_mobile/src/models/item_model.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:rxdart/rxdart.dart';

class CouponDetailBloc extends BlocBase {
  DataService dataService = DataService();

  final _couponDetailStream = BehaviorSubject<Item>();
  final _couponDetailStatusStream = BehaviorSubject<bool>();

  // Stream
  Observable<Item> get couponDetail => _couponDetailStream.stream;
  Observable<bool> get couponDetailStatus => _couponDetailStatusStream.stream;

  // Sink

  getCouponDetail(id) async {
    try {
      final res = await dataService.getItemDetail(id);
      _couponDetailStream.sink.add(res);
      _couponDetailStatusStream.sink.add(true);
    } catch (error) {
      _couponDetailStream.sink.addError(error);
      _couponDetailStatusStream.sink.add(false);
    }
  }

  @override
  void dispose() {
    _couponDetailStream.close();
    _couponDetailStatusStream.close();
  }
}
