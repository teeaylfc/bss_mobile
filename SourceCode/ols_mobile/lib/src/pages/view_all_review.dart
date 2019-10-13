import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/http_client.dart';
import 'package:ols_mobile/src/models/item_detail_model.dart';
import 'package:ols_mobile/src/models/list_review_model.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/error.dart';
import 'package:ols_mobile/src/widgets/refresh_footer.dart';
import 'package:ols_mobile/src/widgets/refresh_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ols_mobile/src/pages/page_state.dart';

class ViewAllReview extends StatefulWidget {
  final int companyId;
  final ItemDetail couponDetail;
  ViewAllReview(this.companyId, this.couponDetail);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ViewAllReviewState();
  }
}

class ViewAllReviewState extends PageState<ViewAllReview> {
  int companyId;
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  Future<ListReview> listReviewFuture;
  ListReview listReview = ListReview();
  var couponDetail;
  ViewAllReviewState();
  DataService dataService = DataService();
  @override
  void initState() {
    super.initState();
    companyId = widget.companyId;
    listReviewFuture = dataService.getListReview(companyId, page);
    print(listReview);
    couponDetail = widget.couponDetail;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          elevation: 0.5,
          title: Text(
            "Rating & Review",
            style: TextStyle(
              color: CommonColor.textBlack,
              fontSize: ScreenUtil().setSp(22),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Container(
        color: Colors.white,
        child: EasyRefresh(
        autoLoad: false,
        key: _easyRefreshKey,
        refreshHeader: CustomRefreshHeader(
          key: _headerKey,
        ),
        refreshFooter: CustomRefreshFooter(
          key: _footerKey,
        ),
        child : SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 9, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 22, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            couponDetail.reviewDTO.averagePoint.toString(),
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(63),
                              color: CommonColor.textGrey,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          Text(
                            "/ 5",
                            style: TextStyle(color: Color(0xFFA9A9A9), fontSize: ScreenUtil().setSp(18)),
                          ),
                        ],
                      ),
                    )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        _buildRatingSummaryItem(context, '★★★★★', couponDetail.reviewDTO.listPoint['excellent'] / 10),
                        _buildRatingSummaryItem(context, '★★★★', couponDetail.reviewDTO.listPoint['good'] / 10),
                        _buildRatingSummaryItem(context, '★★★', couponDetail.reviewDTO.listPoint['everage'] / 10),
                        _buildRatingSummaryItem(context, '★★', couponDetail.reviewDTO.listPoint['poor'] / 10),
                        _buildRatingSummaryItem(context, '★', couponDetail.reviewDTO.listPoint['terrible'] / 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            couponDetail.reviewDTO != null && couponDetail.reviewDTO.totalRate != 0
                                ? (couponDetail.reviewDTO.totalRate.toString() == '1' ?  "1 review"
                                : couponDetail.reviewDTO.totalRate.toString() + ' reviews' )
                                : '0' ' review',
                            style: TextStyle(color: Color(0xFF979797), fontSize: ScreenUtil().setSp(12)),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setSp(34),
                ),
                FutureBuilder<ListReview>(
                    future: listReviewFuture,
                    builder: (context, AsyncSnapshot<ListReview> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("${snapshot.error}"));
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: Container());
                        case ConnectionState.none:
                          return Center(child: Text('No Internet connection found! Please try again'));
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            HttpError error = snapshot.error as HttpError;
                            return Scaffold(
                              body: ErrorPage('Back', () {
                                Navigator.pop(context);
                              }, error.message),
                            );
                          }
                          listReview = snapshot.data;
                          return _buildRatingCommentSection(context);
                        default:
                          Center(child: Text('Load data error....'));
                          return Container();
                      }
                    }),
                SizedBox(
                  height: ScreenUtil().setSp(20),
                )
              ],
            ),
          ),
        ),
          onRefresh: () async {
            refreshData();
          },
          loadMore: () async {
            loadMoreData();
          },
        ),
      ),
    );
  }
  _buildRatingSummaryItem(context, text, percent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(color: Color(0xFF979797), fontSize: ScreenUtil().setSp(13)),
        ),
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width / 2.6,
          lineHeight: 4.0,
          percent: percent,
          linearStrokeCap: LinearStrokeCap.roundAll,
          backgroundColor: Color(0xFFD8D8D8),
          progressColor: Color(0xffA9A9A9),
        ),
      ],
    );
  }

  _buildRatingCommentSection(context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listReview.content.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRatingCommentCard(context, listReview.content[index]);
        });
  }

  _buildRatingCommentCard(context, Review review) {
      return Container(
        padding: EdgeInsets.only(top: 5),
        constraints: BoxConstraints(minHeight: ScreenUtil().setSp(83)),
        child: Card(
          elevation: 0.2,
          color: Color(0xFFF7F7F7),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      review.tittle ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: (CommonColor.textBlack),fontSize: ScreenUtil().setSp(10), fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      dateFormat(review.createdDate) ?? '',
                      style: TextStyle(color: Color(0xFF979797), fontSize: ScreenUtil().setSp(10)),
                    ),

                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setSp(3),
                ),
                Row(
                  children: <Widget>[
                    FlutterRatingBar(
                      initialRating: review.rate != null ? review.rate.toDouble() : 0,
                      itemSize: ScreenUtil().setSp(12),
                      fillColor: Color(0xFFF76016),
                      borderColor: Color(0xFFF76016),
                      allowHalfRating: true,
                      ignoreGestures: true,
                      onRatingUpdate: (rating) {
                      },
                    ),
                    Spacer(),
                    Text(
                      review.consumerName ?? "",
                      style: TextStyle(color: Color(0xFF979797), fontSize: ScreenUtil().setSp(9)),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setSp(5),
                ),
                Text(review.review ?? '', style: TextStyle(color: Color(0xFF585858), fontSize: ScreenUtil().setSp(12)))
              ],
            ),
          ),
        ),
      );
  }

  @override
  Future initData(){
    listReview = ListReview();
    page = 1;
  }

  @override
  Future loadMoreData() async{
   if(!listReview.last){
     setState(() {
       page++;
       listReviewFuture = dataService.getListReview(companyId, page);
     });
   }else{
     print("last page");
   }
  }

  @override
  Future refreshData() async{
   setState(() {
     page = 1;
//     listReviewFuture = Future.delayed(Duration(milliseconds: 1000));
     listReviewFuture =  dataService.getListReview(companyId, page);
   });
  }

  String dateFormat(text){
    String s;
    DateTime d = DateFormat("MM/dd/yyyy HH:mm:ss","en_US").parse(text);
    s = DateFormat("HH:mm  dd.MM.yyyy").format(d).toString();
    return s;
  }
}
