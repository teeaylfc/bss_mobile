import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/models/category_model.dart';
import 'package:bss_mobile/src/models/list_item_model.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BlocBase {
  DataService dataService = DataService();

  final _selectedCategoryStream = BehaviorSubject<Category>();

  final _categoryListStream = BehaviorSubject<CategoryList>();
  final _browserCategoryStream = BehaviorSubject<CategoryList>();
  final _itemByCategoryStream = BehaviorSubject<ListItem>();

  // Stream
  Observable<CategoryList> get allCategory => _categoryListStream.stream;
  ValueObservable<CategoryList> get allCategoryValue => _categoryListStream.stream;

  Observable<CategoryList> get browserCategoryList => _browserCategoryStream.stream;
  Observable<ListItem> get couponByCategoryList => _itemByCategoryStream.stream;
  Observable<Category> get selectedCategory => _selectedCategoryStream.stream;

  Future<CategoryList> getAllCategory(page) async {
     return await dataService.getAllCategory();
      // _categoryListStream.sink.add(response);
      // return response;
  }

  browserCategory(page) async {
    try {
      final response = await dataService.getBrowserCategory(page);
      _browserCategoryStream.sink.add(CategoryList(response, true));
    } catch (error) {
      _browserCategoryStream.sink.addError(error);
    }
  }

  Future<ListItem> getCouponByCategory(categoryId, page) async {
      return await dataService.getItemByCategory(categoryId, page);
      // return response;
      // _itemByCategoryStream.sink.add(response);
  }

  changeSelectedCategory(Category category) {
    print(category.categoryDescription);
    _selectedCategoryStream.sink.add(category);
  }

  @override
  void dispose() {
    _categoryListStream.close();
    _browserCategoryStream.close();
    _itemByCategoryStream.close();
    _selectedCategoryStream.close();
  }
}

final categoryBloc = CategoryBloc();
