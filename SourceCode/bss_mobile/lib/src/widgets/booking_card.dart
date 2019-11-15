import 'package:auto_size_text/auto_size_text.dart';
import 'package:bss_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/util/image_util.dart';
import 'package:bss_mobile/src/models/booking_model.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingCard extends StatelessWidget {
  DataService dataService = DataService();

  final Booking booking;
  final double width;
  final double height;
  final double paddingBottom;
  final double paddingRight;
  final double imageHeight;
  final double middleHeight;
  final String pageContext;
  final String previousStatus;
  final String previousPage;

  Color bookingBgColor;
  String bookingStatusText;
  Color bookingStatusTextColor;

  BitmapDescriptor markerIcon;

  BookingCard(
      {this.booking,
      this.width,
      this.height,
      this.paddingBottom,
      this.paddingRight,
      this.imageHeight,
      this.middleHeight,
      this.pageContext,
      this.previousStatus,
      this.previousPage}) {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(26, 26)), 'assets/images/map-pin2.png').then((onValue) {
      markerIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildBookingStatusStyle(booking.bookingStatus);

    dynamic imageWidget;
    var image = ImageUtil.getImageUrl(booking.offerImage);
    if (image == null) {
      imageWidget = AssetImage('assets/images/no-image.jpg');
    } else if (image.startsWith('http')) {
      imageWidget = NetworkImage(image);
    } else {
      imageWidget = AssetImage(image);
    }

    return GestureDetector(
      onTap: () {
        bottomNavBarBloc
            .pickItem(PageIndex.BOOKING_DETAIL, {'id': booking.id, 'markerIcon': markerIcon, 'previousStatus': previousStatus, 'previousPage': previousPage});
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, paddingRight, paddingBottom),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Color(0xFFE7E7E7), width: 0.5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE7E7E7),
                    blurRadius: 2,
                    offset: new Offset(0.0, 0.2),
                  )
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                      width: width,
                      height: imageHeight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.darken), fit: BoxFit.cover, image: imageWidget),)),
                  Container(
                    padding: EdgeInsets.only(top: 11, left: 11, right: 11, bottom: 11),
                    height: middleHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AutoSizeText(booking.storeName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold)),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.schedule,
                                size: ScreenUtil().setSp(14),
                                color: Color(0xFFA9A9A9),
                              ),
                              SizedBox(width: 5),
                              'LIST_SMALL' == pageContext
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          Booking.getBookingTime(booking.bookingDate) ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(12)),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setSp(2),
                                        ),
                                        Text(
                                          Booking.getBookingDate(booking.bookingDate) ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(12)),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      Booking.getBookingTime(booking.bookingDate) + ' ' + Booking.getBookingDate(booking.bookingDate),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(12)),
                                    ),
                              Spacer(),
                              'LIST' == pageContext ? _buildBookingStatus() : Container()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          'LIST_SMALL' == pageContext ? Positioned(top: 27, child: _buildBookingStatus()) : Container()
        ],
      ),
    );
  }

  _buildBookingStatus() {
    return Container(
      height: ScreenUtil().setSp(15),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: bookingBgColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        bookingStatusText ?? '',
        style: TextStyle(color: bookingStatusTextColor, fontSize: ScreenUtil().setSp(8)),
      ),
    );
  }

  _buildBookingStatusStyle(bookingStatus) {
    if (bookingStatus == BookingStatus.WAITING_FOR_CONFIRMATION) {
      bookingBgColor = Color(0xFFEB5757);
      bookingStatusText = 'Waiting for confirmation';
      bookingStatusTextColor = Color(0xFFFFFFFF);
    } else if (bookingStatus == BookingStatus.CONFIRMED) {
      bookingBgColor = Color(0xFF27AE60);
      bookingStatusText = 'Confirmed';
      bookingStatusTextColor = Color(0xFFFFFFFF);
    } else if (bookingStatus == BookingStatus.CONSUMER_CANCEL) {
      bookingBgColor = Colors.orange;
      bookingStatusText = 'Cancel';
      bookingStatusTextColor = Color(0xFFFFFFFF);
    } else if (bookingStatus == BookingStatus.EXPIRED) {
      bookingBgColor = Colors.grey;
      bookingStatusText = 'Expired';
      bookingStatusTextColor = Colors.white;
    }
  }
}
