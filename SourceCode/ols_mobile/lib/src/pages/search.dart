import 'dart:async';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class SearchPage extends StatefulWidget {
  final String keyword;

  SearchPage({this.keyword}) {}

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final DataService dataService = DataService();

  AnimationController _animationController;

  // SearchContainer height.
  Animation _containerHeight;

  // Place options opacity.
  Animation _listOpacity;

  bool loading = false;
  FocusNode _searchFocusNode;
  TextEditingController _keywordController;
  var searchHistory = [];
  var suggestions = [];
  var predictions = [];
  bool showClearIcon = false;
  Timer debounceTimer;

  String keyword;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _containerHeight = Tween<double>(begin: 0, end: 800).animate(
      CurvedAnimation(
        curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );
    _listOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );

    _keywordController = TextEditingController(text: widget.keyword ?? '');
    _getSearchHistory();
    _searchFocusNode = FocusNode();
    Timer(Duration(milliseconds: 500), () {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });

    _keywordController.addListener(() {
      _showHideClearIcon();
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }
      if (_keywordController.text == null ||
          _keywordController.text.trim().length == 0) {
        _autocompletePlace('');
      }
      debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (this.mounted &&
            _keywordController.text != null &&
            _keywordController.text.trim().length > 0) {
          _autocompletePlace(_keywordController.text);
        }
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 8.0,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Color(0xffF76016),
        ),
        automaticallyImplyLeading: false,
        title: _buildSearchField(),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)])
          ),
        ),
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () {
                  _searchFocusNode.unfocus();
                  Navigator.of(context).pop();
                  // bottomNavBarBloc.pickItem(1);
                },
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        child: Stack(
          children: <Widget>[
            ListView(children: <Widget>[
              // _suggestionContainer(),
              ///// Recent searches
              SizedBox(
                height: ScreenUtil().setSp(20),
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Recent searches',
                    style: TextStyle(
                        color: Color(0xFFA9A9A9),
                        fontSize: ScreenUtil().setSp(13)),
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

              new Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: List.generate(
                  searchHistory.length,
                  (i) => FilterChip(
                    backgroundColor: Color(0xFFF1F3F4),
                    label: Text(
                      searchHistory[i],
                      style: TextStyle(
                          color: CommonColor.textBlack,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(14)),
                    ),
                    onSelected: (bool value) {
                      _chipClick(searchHistory[i].toString());
                    },
                  ),
                ).toList(),
              ),

              SizedBox(
                height: ScreenUtil().setSp(30),
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Top categories',
                    style: TextStyle(
                        color: Color(0xFFA9A9A9),
                        fontSize: ScreenUtil().setSp(13)),
                  ),
                  // Spacer(),
                  // Icon(Icons.cancel, color: Color(0xFFBDBDBD), size: 18,)
                ],
              ),
              SizedBox(
                height: ScreenUtil().setSp(20),
              ),
              Row(
                children: <Widget>[
                  FilterChip(
                    backgroundColor: Color(0xFFF1F3F4),
                    label: Text(
                      "Restaurants",
                      style: TextStyle(color: CommonColor.textGrey),
                    ),
                    onSelected: (bool value) {
                      print("selected");
                    },
                  ),
                  SizedBox(
                    width: ScreenUtil().setSp(10),
                  ),
                  FilterChip(
                    backgroundColor: Color(0xFFF1F3F4),
                    label: Text(
                      "Spa",
                      style: TextStyle(color: CommonColor.textGrey),
                    ),
                    onSelected: (bool value) {
                      print("selected");
                    },
                  ),
                ],
              )
              // End List Chips
            ]),
            Positioned(
              top: 0,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                child: _suggestionContainer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSearchField() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: TextField(
            focusNode: _searchFocusNode,
            autofocus: true,
            controller: _keywordController,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            style: new TextStyle(
                color: Color(0xFFB1B1B1), fontSize: ScreenUtil().setSp(14)),
            decoration: InputDecoration(
              hintText: FlutterI18n.translate(context, "search_header.hint"),
              border: InputBorder.none,
              hintStyle: TextStyle(color: Color(0xFFB1B1B1)),
              contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              prefixIcon: Padding(
                padding: EdgeInsetsDirectional.only(start: 12.0),
                child: Icon(
                  Icons.search,
                  color: Color(0xff898989),
                ),
              ),
              suffixIcon: showClearIcon
                  ? IconButton(
                      onPressed: _clearkeyword,
                      icon: Icon(
                        Icons.cancel,
                        color: Color(0xff898989),
                        size: 20,
                      ),
                    )
                  : Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
            ),
            onSubmitted: _handleSubmit,
          ),
        ));
  }

  // Methods
  void _autocompletePlace(String input) async {
    if (input.length > 0) {
      final pre = await dataService.searchSuggestion(input, 15);
      await _animationController.animateTo(0.5);

      // final pre = suggestions.where((i) => i.toString().contains(input)).toList();
      await _animationController.animateTo(0.5);
      setState(() {
        keyword = input;
        predictions = pre;
      });
      await _animationController.forward();
    } else {
      await _animationController.animateTo(0.5);
      setState(() => predictions = []);
      await _animationController.reverse();
    }
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
      // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1, spreadRadius: 1)],
    );
  }

  // Widgets
  Widget _suggestionContainer() {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Container(
            height: _containerHeight.value,
            decoration: _containerDecoration(),
            alignment: Alignment.center,
            child: Opacity(
              opacity: _listOpacity.value,
              child: ListView(
                children: <Widget>[
                  if (predictions.length > 0)
                    for (var prediction in predictions)
                      _predictOption(prediction),
                ],
              ),
            ),
          );
        });
  }

  Widget _predictOption(String prediction) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _chipClick(prediction);
          },
          child: Container(
            height: ScreenUtil().setSp(30),
            alignment: Alignment.bottomLeft,
            child: _highlightKeyword(context, prediction, keyword),
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _highlightKeyword(
    BuildContext context,
    text,
    wordToStyle,
  ) {
    final style =
        TextStyle(color: CommonColor.textGrey, fontWeight: FontWeight.bold);
    final spans = _getSpans(text, wordToStyle, style);

    return RichText(
      text: TextSpan(
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: CommonColor.textGrey),
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

  _showHideClearIcon() {
    if (_keywordController.text != null && _keywordController.text.length > 0) {
      setState(() {
        showClearIcon = true;
      });
    } else {
      setState(() {
        showClearIcon = false;
      });
    }
  }

  _clearkeyword() {
    _keywordController.text = '';
  }

  void _handleSubmit(String value) {
    _searchFocusNode.unfocus();
    Timer(Duration(milliseconds: 200), () {
      Navigator.of(context).pop();
      bottomNavBarBloc.pickItem(PageIndex.COUPON_LIST,
          {'keyword': _keywordController.text, 'previousPage': 'SEARCH'});
    });
  }

  void _chipClick(String value) {
    _searchFocusNode.unfocus();
    // Timer(Duration(milliseconds: 200), () {
    Navigator.of(context).pop();
    bottomNavBarBloc.pickItem(
        PageIndex.COUPON_LIST, {'keyword': value, 'previousPage': 'SEARCH'});
    // });
  }

  _clearSearchHistory() async {
    try {
      setState(() {
        loading = true;
      });
      await dataService.clearSearchHistory();

      setState(() {
        loading = false;
        searchHistory = [];
      });
    } catch (error) {
      setState(() {
        loading = false;
      });
      Reusable.showTotastError(error.message);
    }
  }

  _getSearchHistory() async {
    var res = await dataService.searchHistory();
    if (res != null) {
      setState(() {
        searchHistory = res['searchHistory'];
        suggestions = res['suggestions'];
      });
    }
  }
}
