import 'package:flutter/material.dart';
import 'package:bss_mobile/src/blocs/category_bloc.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/http_client.dart';
import 'package:bss_mobile/src/models/category_model.dart';
import 'package:bss_mobile/src/pages/loading-list.dart';
import 'package:bss_mobile/src/pages/page_state.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/category_card.dart';
import 'package:bss_mobile/src/widgets/search.dart';

class CategoryListPage extends StatefulWidget {
  CategoryListPage() {}

  @override
  State<StatefulWidget> createState() {
    return _CategoryListPageState();
  }
}

class _CategoryListPageState extends PageState<CategoryListPage> {
  List<Category> listCategory = List<Category>();
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(gradient: LinearGradient(colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color(0xffF42E13),
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Color(0xffF76016),
            ),
            automaticallyImplyLeading: false,
            titleSpacing: 0.0,
            title: SearchField(),
          ),
          body: Container(
            color: CommonColor.backgroundColor,
            child: Container(
              color: CommonColor.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: FutureBuilder<CategoryList>(
                    future: categoryBloc.getAllCategory(page),
                    builder: (context, AsyncSnapshot<CategoryList> snapshot) {
                      if (snapshot.hasError) {
                        HttpError error = snapshot.error as HttpError;
                        return Center(child: Text(error.message));
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return LoadingListPage();
                        case ConnectionState.none:
                          return Center(child: Text('No Internet connection found! Please try again'));
                        case ConnectionState.done:
                          return buildListCategory(snapshot, categoryBloc);

                        default:
                          Center(child: Text('Load data error....'));
                      }
                    }),
              ),
            ),
          )),
    );
  }

  Widget buildListCategory(AsyncSnapshot<CategoryList> snapshot, categoryBloc) {
    if (snapshot.hasData) {
      listCategory.addAll(snapshot.data.content);
    }
    final double itemHeight = ScreenUtil().setSp(167);
    final double itemWidth = ScreenUtil().setSp(166);
    return GridView.count(
      crossAxisSpacing: ScreenUtil().setSp(12),
      mainAxisSpacing: ScreenUtil().setSp(12),
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / itemHeight),
      children: List.generate(listCategory.length, (index) {
        var item = listCategory[index];
        return CategoryCard(
          category: item,
          width: ScreenUtil().setSp(166),
          height: ScreenUtil().setSp(167),
          imageHeight: ScreenUtil().setSp(127),
          paddingRight: ScreenUtil().setSp(0),
          displayType: 'GIRD',
        );
      }),
    );
  }

  @override
  Future initData() {
    return null;
  }

  @override
  Future loadMoreData() {
    if (!last) {
      page = page + 1;
      categoryBloc.getAllCategory(page);
    } else {
      print('last page..........');
    }
  }

  @override
  Future refreshData() {
    setState(() {
      listCategory = [];
      page = 0;
    });
    categoryBloc.getAllCategory(page);
  }
}
