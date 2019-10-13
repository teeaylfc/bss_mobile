import 'dart:async';

import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/exception/http_code.dart';
import 'package:ols_mobile/src/common/exception/http_error_event.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/http_client.dart';
import 'package:ols_mobile/src/models/booking_model.dart';
import 'package:ols_mobile/src/models/user_modal.dart';
import 'package:ols_mobile/src/pages/login.dart';
import 'package:ols_mobile/src/pages/page_state.dart';
import 'package:ols_mobile/src/pages/qr_scanner.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/booking_card.dart';
import 'package:ols_mobile/src/widgets/refresh_footer.dart';
import 'package:ols_mobile/src/widgets/refresh_header.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intl/intl.dart';

class BookingAllPage extends StatefulWidget {
  final object;
  BookingAllPage({
    Key key,
    this.object,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _BookingAllPageState();
  }
}

class _BookingAllPageState extends PageState<BookingAllPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  final formatCurrency = NumberFormat.simpleCurrency();

  DataService dataService = DataService();

  ApplicationBloc applicationBloc;
  List<Booking> listBooking = List<Booking>();
  User currentUser;
  EventBus eventBus = EventBus();

  List<int> selectedOffer;

  String selectedStatus;

  @override
  void initState() {
    super.initState();
    if (widget.object['previousStatus'] == null || widget.object == null) {
      selectedStatus = BookingStatus.BOOKING_UP_COMING;
    } else if (widget.object['previousStatus'] == 'HISTORY') {
      selectedStatus = BookingStatus.HISTORY;
    } else {
      selectedStatus = BookingStatus.BOOKING_UP_COMING;
    }
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    listBooking = List<Booking>();

    currentUser = applicationBloc.currentUserValue.value;
    if (currentUser != null) {
      refreshData();
    }

    HttpCode.eventBus.on<HttpErrorEvent>().listen((event) {
      if (event.code == 401) {
        BlocProvider.of<ApplicationBloc>(context).logout();
        HttpCode.eventBus.destroy();
        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new LogInPage();
            },
            fullscreenDialog: true));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            automaticallyImplyLeading: true,
            centerTitle: true,
            iconTheme: IconThemeData(color: CommonColor.textBlack),
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 15,
              ),
              onPressed: () => bottomNavBarBloc.pickItem(PageIndex.PROFILE),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Your bookings',
                  style: TextStyle(fontSize: ScreenUtil().setSp(16), color: CommonColor.textBlack),
                )
              ],
            ),
          ),
          body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                //// Tab
                _buildTab(),
                //// List coupon

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: _buildListBooking(),
                  ),
                ),
              ],
            ),
          ),
        )
        ///// Avatar
      ],
    );
  }

  Widget _buildListBooking() {
    return EasyRefresh(
      autoLoad: false,
      key: _easyRefreshKey,
      refreshHeader: CustomRefreshHeader(
        key: _headerKey,
      ),
      refreshFooter: CustomRefreshFooter(
        key: _footerKey,
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var item = listBooking[index];
                return Stack(
                  children: <Widget>[
                    BookingCard(
                      booking: item,
                      width: ScreenUtil().setSp(345),
                      height: ScreenUtil().setSp(246),
                      imageHeight: ScreenUtil().setSp(176),
                      middleHeight: 66,
                      paddingBottom: 20,
                      paddingRight: 0,
                      pageContext: "LIST",
                      previousPage: "BOOKING",
                      previousStatus: selectedStatus == BookingStatus.HISTORY ? "HISTORY" : null,
                    )
                  ],
                );
              },
              childCount: listBooking.length,
            ),
          ),
        ],
      ),
      onRefresh: () async {
        refreshData();
      },
      loadMore: () async {
        loadMoreData();
      },
    );
  }

  _buildTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: <Widget>[
          ChoiceChip(
            selected: BookingStatus.BOOKING_UP_COMING == selectedStatus,
            selectedColor: Color(0xFFF1F3F4),
            backgroundColor: Colors.white,
            label: Text(
              "Upcoming",
              style: TextStyle(
                color: BookingStatus.BOOKING_UP_COMING == selectedStatus ? CommonColor.textBlack : Color(0xFF9B9B9B),
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(14),
              ),
            ),
            onSelected: (bool value) {
              setState(() {
                selectedStatus = BookingStatus.BOOKING_UP_COMING;
                refreshData();
              });
            },
          ),
          SizedBox(
            width: ScreenUtil().setSp(20),
          ),
          ChoiceChip(
            selected: BookingStatus.HISTORY == selectedStatus,
            selectedColor: Color(0xFFF1F3F4),
            backgroundColor: Colors.white,
            label: Text(
              "History",
              style: TextStyle(
                  color: BookingStatus.HISTORY == selectedStatus ? CommonColor.textBlack : Color(0xFF9B9B9B),
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(14)),
            ),
            onSelected: (bool value) {
              setState(() {
                selectedStatus = BookingStatus.HISTORY;
                refreshData();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Future initData() {
    setState(() {
      listBooking = [];
    });
  }

  @override
  Future loadMoreData() async {
    if (!last) {
      page = page + 1;
      getBooking();
    } else {
      print('last page..........');
    }
  }

  @override
  Future refreshData() async {
    page = 1;
    getBooking();
  }

  getBooking() {
    dataService.getBooking(page, selectedStatus).then((data) {
      setState(() {
        if (page == 1) {
          listBooking = [];
        }
        listBooking.addAll(data.content);
        last = data.last;
      });
    }).catchError((error) {
     Reusable.handleHttpError(context, error,'');

    });
  }
}
