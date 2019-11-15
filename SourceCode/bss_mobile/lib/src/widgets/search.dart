import 'package:bss_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/pages/main.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/search_delegate.dart' as cyw;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bss_mobile/src/models/category_model.dart';

class SearchField extends StatelessWidget {
  final String keyword;
  final bool paddingLeft;
  final Function callbackSearch;
  final Function callbackGetByCategory;
  final Color bgColor;
  final DataService dataService = DataService();

  TextEditingController _controller;

  SearchField({this.keyword, this.paddingLeft = true, this.callbackSearch, this.callbackGetByCategory, this.bgColor}) {
    _controller = TextEditingController(text: keyword);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        cyw.showSearch(context: context, delegate: SearchBarDelegate(dataService.searchHistory())).then((data) {
          if (data is String && callbackSearch != null) {
            callbackSearch(data);
          } else if (data is Category && callbackGetByCategory != null) {
            callbackGetByCategory(data);
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(paddingLeft ? 10 : 0, 10, 10, 10),
        child: Container(
          decoration: BoxDecoration(color: bgColor != null? bgColor: Colors.white , borderRadius: BorderRadius.circular(39)),
          child: TextField(
              controller: _controller,
              enabled: false,
              autofocus: false,
              style: new TextStyle(color: Color(0xFFB1B1B1), fontSize: ScreenUtil().setSp(14)),
              decoration: const InputDecoration(
                  hintText: 'Nhập thương hiệu dịch vụ bạn tìm kiếm',
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Color(0xFFB1B1B1)),
                  contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12.0),
                    child: Icon(
                      Icons.search,
                      color: Color(0xff898989),
                    ),
                  ))),
        ),
      ),
    );
  }
}

class SearchBarDelegate extends cyw.SearchDelegate<dynamic> {
  final DataService dataService = DataService();
  Category category;
  Future recentSearchFuture;
  var recentSearch = [];

  SearchBarDelegate(recentSearchFuture) {
    this.recentSearchFuture = recentSearchFuture;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      InkWell(
        onTap: () {
          close(context, null);
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Text(
              'Hủy',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xff343434)),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    _submitSearch(context, query.trim());
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().length >= 2) {
      return FutureBuilder(
          future: dataService.searchSuggestion(query.trim(), 15),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
//              final suggestionList = snapshot.data;
              final suggestionList = ["buffet1","buffer2"];
              return Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: suggestionList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        _submitSearch(context, suggestionList[index]);
                      },
                      title: _highlightKeyword(context, suggestionList[index], query.trim()),
                    );
                  },
                ),
              );
            } else {
              return Container(
                color: Colors.white,
                child: Center(
                  child: SpinKitFadingCircle(
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              );
            }
          });
    }
    // return Container();
    return _buildRecents(context);
  }

  @override
  Widget buildRecentSearch(BuildContext context) {
    return _buildRecents(context);
  }

  _buildRecents(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      child: ListView(children: <Widget>[
        ///// Recent searches
        SizedBox(
          height: ScreenUtil().setSp(20),
        ),
        FutureBuilder(
          future: recentSearchFuture,
          builder:(context, snapshot) {
            if (snapshot.hasData) {
              recentSearch = snapshot.data['searchHistory'];
              if(recentSearch.length != 0){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Tìm kiếm gần đây',
                        style: TextStyle(color: Color(0xFFA9A9A9),
                            fontSize: ScreenUtil().setSp(12)),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: _clearSearchHistory,
                          icon: Icon(
                            Icons.cancel,
                            color: Color(0xFFBDBDBD),
                            size: 20,
                          ))
                    ],
                  ),
                  _buildRecentsChip(context)
                ],
              );}else{
                return Container();
              }
            }else{
              return Center(
                child: SpinKitFadingCircle(
                  color: Colors.grey,
                  size: 30,
                ),
              );
            }
          },
        ),
        SizedBox(
          height: ScreenUtil().setSp(27),
        ),
        Text(
          'Gợi ý cho bạn',
          style: TextStyle(color: Color(0xFFA9A9A9), fontSize: ScreenUtil().setSp(12)),
        ),
        SizedBox(
          height: ScreenUtil().setSp(20),
        ),
        _buildTopCategoriesChip(context)
      ]),
    );
  }

  _buildTopCategoriesChip(context) {
    var categories = storage.getItem('categories');
    if (categories == null) {
      categories = [];
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(
        categories.length,
        (i) {
//          final category = Category.fromJson(categories[i]);
          return Container(
            height: ScreenUtil().setSp(30),
            child: FilterChip(
              backgroundColor: Color(0xFFF1F3F4),
              label: Text(
//                category.categoryDescription ?? "",
              "",
                style: TextStyle(color: CommonColor.textGrey, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
              ),
              onSelected: (bool value) {
                _submitCategory(context, category);
              },
            ),
          );
        },
      ).toList(),
    );
  }

  void _submitCategory(context, category) {
    close(context, category);
    bottomNavBarBloc.pickItem(PageIndex.COUPON_LIST, {'category': category, 'previousPage': 'CATEGORY'});
  }

  _buildRecentsChip(context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(
        recentSearch.length,
        (i) => Container(
            height: ScreenUtil().setSp(30),
          child: FilterChip(
            backgroundColor: Color(0xFFF1F3F4),
            label: Text(
              recentSearch[i],
              style: TextStyle(color: CommonColor.textBlack, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
            ),
            onSelected: (bool value) {
              _submitSearch(context, recentSearch[i].toString());
            },
          ),
        ),
      ).toList(),
    );
  }

  void _submitSearch(context, String value) {
    close(context, value);
    bottomNavBarBloc.pickItem(PageIndex.COUPON_LIST, {'keyword': value, 'previousPage': 'SEARCH'});
  }

  _clearSearchHistory() async {
    try {
      await dataService.clearSearchHistory();
    } catch (error) {}
  }

  Widget _highlightKeyword(
    BuildContext context,
    text,
    wordToStyle,
  ) {
    final style = TextStyle(color: CommonColor.textGrey, fontWeight: FontWeight.bold);
    final spans = _getSpans(text, wordToStyle, style);

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: CommonColor.textGrey),
        children: spans,
      ),
    );
  }

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle style) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;
    do {
      // look for the next match
      final startIndex = text.indexOf(matchWord, spanBoundary);
      // if no more matches then add the rest of the string without style
      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }
      // add any unstyled text before the next match
      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }
      // style the matched text
      final endIndex = startIndex + matchWord.length;
      final spanText = text.substring(startIndex, endIndex);
      spans.add(TextSpan(text: spanText, style: style));
      // mark the boundary to start the next search from
      spanBoundary = endIndex;
      // continue until there are no more matches
    } while (spanBoundary < text.length);

    return spans;
  }
}
