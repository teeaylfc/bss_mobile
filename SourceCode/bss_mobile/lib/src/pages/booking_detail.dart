import 'dart:async';

import 'package:bss_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/models/booking_model.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/confirm_dialog.dart';
import 'package:bss_mobile/src/widgets/notification_popup.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
import 'package:bss_mobile/src/widgets/section_title.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'coupon_detail.dart';

class BookingDetailPage extends StatefulWidget {
  final int id;
  BitmapDescriptor markerIcon;
  final String previousStatus;
  final String previousPage;

  BookingDetailPage({this.id, this.markerIcon, this.previousStatus, this.previousPage});

  @override
  State<StatefulWidget> createState() {
    return _BookingDetailPageState();
  }
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DeviceCalendarPlugin deviceCalendar = new DeviceCalendarPlugin();

  DataService dataService = DataService();

  GoogleMapController mapController;

  List<Calendar> _calendars;
  Calendar _selectedCalendar;

  Color bookingBgColor;
  String bookingStatusText = '';
  Color bookingStatusTextColor;

  Booking booking;
  Set<Marker> markers = Set();
  double latitude;
  double longitude;

  @override
  void initState() {
    super.initState();
    _retrieveCalendars();
    getBookingDetail();
  }

  void _onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _whereare(latitude, longitude, storeName, addressFulfillment) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(latitude, longitude), zoom: 15.0)));
    Marker resultMarker = Marker(
      markerId: MarkerId(storeName),
      infoWindow: InfoWindow(title: storeName, snippet: addressFulfillment),
      position: LatLng(latitude, longitude),
      icon: widget.markerIcon,
    );
    markers.add(resultMarker);
  }

  getBookingDetail() {
    if (widget.id != null) {
      dataService.getBookingDetai(widget.id).then((value) {
        print(value.bookingStatus);
        setState(() {
          booking = value;
          _buildBookingStatus(booking.bookingStatus);
        });
        // Create a new marker
        if (value.storeLatitude != null && value.storeLongitude != null) {
          _whereare(value.storeLatitude, value.storeLongitude, value.storeName, value.addressFulfillment);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var bookingDatetime = '';
    if (booking != null && booking.bookingDate != null) {
      bookingDatetime = Booking.getBookingTime(booking.bookingDate) + ' ' + Booking.getBookingDate(booking.bookingDate);
    }
    var contactInfo = '';
    if (booking != null) {
      if (booking.contactName != null) {
        contactInfo = booking.contactName;
      }
      if (contactInfo.length > 0) {
        contactInfo = contactInfo + ' - ';
      }
      if (booking.contactPhone != null) {
        contactInfo = contactInfo + booking.contactPhone;
      }
    }

    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(color: CommonColor.textRed),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(booking?.storeName ?? ''),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Navigator.of(context).pop();
            print(widget.previousStatus.toString() + "      " + widget.previousPage.toString());
            if (widget.previousPage != null) {
              if (widget.previousPage == "BOOKING") {
                bottomNavBarBloc.pickItem(PageIndex.BOOKING_LIST, {'previousStatus': widget.previousStatus});
              }
            } else {
              bottomNavBarBloc.pickItem(PageIndex.PROFILE, '');
            }
          },
        ),
        actions: <Widget>[
          // new IconButton(
          //   icon: new Icon(Icons.close),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //     // bottomNavBarBloc.pickItem(4);
          //   },
          // ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          // Map
          Container(
            width: ScreenUtil().setSp(200),
            height: ScreenUtil().setSp(200),
            child: GoogleMap(
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(21.885206, -102.291557),
                zoom: 15,
              ),
              markers: markers,
              onMapCreated: _onMapCreated,
            ),
          ),
          SectionTitle(
            'Booking details',
            Chip(
                backgroundColor: bookingBgColor,
                label: Text(
                  bookingStatusText ?? '',
                  style: TextStyle(
                    color: bookingStatusTextColor,
                    fontSize: ScreenUtil().setSp(11),
                  ),
                )),
          ),

          _buildSection(
              context,
              Image.asset(
                'assets/images/map-pin.png',
                width: ScreenUtil().setSp(20),
                height: ScreenUtil().setSp(20),
              ),
              booking?.storeName ?? '',
              booking?.addressFulfillment ?? '',
              null),
          _buildSection(
              context,
              Image.asset(
                'assets/images/percent.png',
                width: ScreenUtil().setSp(20),
                height: ScreenUtil().setSp(20),
              ),
              'Coupon value',
              booking?.offerName ?? '', () {
            Navigator.of(context).push(
              PageTransition(
                type: PageTransitionType.slideZoomUp,
                child: ItemDetailPage(
                  itemCode: booking.offerId,
                  heroTag: booking.offerId,
                ),
              ),
            );
          }),
          _buildSection(
              context,
              Image.asset(
                'assets/images/clock.png',
                width: ScreenUtil().setSp(20),
                height: ScreenUtil().setSp(20),
              ),
              bookingDatetime,
              'Add to calendar',
              _addBookingToCalendarEvent,
                hightLight: true),
          _buildSection(
              context,
              Image.asset(
                'assets/images/user_2.png',
                width: ScreenUtil().setSp(20),
                height: ScreenUtil().setSp(20),
              ),
              'Contact',
              contactInfo,
              _openCall,
              hightLight: true)
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  _buildBottomButton() {
    return Container(
      height: ScreenUtil().setSp(80),
      padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Divider(),
          (booking != null)
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          booking.bookingStatus != BookingStatus.EXPIRED
                              ? bottomNavBarBloc.pickItem(PageIndex.BOOKING, {
                                  'couponId': booking.offerId,
                                  'merchantName': booking.storeName,
                                  'listStores': booking.listStores,
                                  'markerIcon': widget.markerIcon,
                                  'booking': booking,
                                })
                              : bottomNavBarBloc.pickItem(PageIndex.BOOKING, {
                                  'couponId': booking.offerId,
                                  'merchantName': booking.storeName,
                                  'listStores': booking.listStores,
                                  'markerIcon': widget.markerIcon,
                                });
                        },
                        child: Text(
                          booking.bookingStatus != BookingStatus.EXPIRED && booking.bookingStatus != BookingStatus.CONSUMER_CANCEL ? 'Edit' : 'Rebook',
                          style: TextStyle(color: CommonColor.textGrey),
                        ),
                        color: Color(0xFFEAEAEA),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setSp(20)),
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          (booking.bookingStatus == BookingStatus.EXPIRED || booking.bookingStatus == BookingStatus.CONSUMER_CANCEL)
                              ? _asyncConfirmDeleteBookingDialog(context)
                              : _asyncConfirmCancelBookingDialog(context);
                        },
                        child: Text(
                            booking.bookingStatus == BookingStatus.EXPIRED || booking.bookingStatus == BookingStatus.CONSUMER_CANCEL ? 'Delete' : 'Cancel',
                            style: TextStyle(color: Colors.white)),
                        color: Color(0xFFFB101B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                      ),
                    ),
                  ],
                )
              : Container(
                  height: ScreenUtil().setSp(40),
                ),
        ],
      ),
    );
  }

  _buildSection(context, icon, title, content, ontap, {hightLight}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
              leading: Container(
                padding: EdgeInsets.only(top: 5),
                child: icon,
              ),
              title: Text(
                title,
                style: TextStyle(color: CommonColor.textBlack, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              subtitle: InkWell(
                onTap: () {
                  if (ontap != null) {
                    ontap();
                  }
                },
                child: Text(
                  content,
                  style: TextStyle(color: hightLight == null || hightLight == false ? CommonColor.textGrey : CommonColor.textRed,                          fontSize: ScreenUtil().setSp(12)),
                ),
              ),
              contentPadding: EdgeInsets.all(0))
        ],
      ),
    );
  }

  Future<ConfirmAction> _asyncConfirmCancelBookingDialog(BuildContext context) async {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: ConfirmDialog(
                width: 297,
                height: 310,
                image: 'assets/images/sad_face.png',
                headline: 'We are sorry to hear that!',
                title: 'Are you sure to cancel this booking?',
                callbackConfirm: cancelBooking,
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  Future<ConfirmAction> _asyncConfirmDeleteBookingDialog(BuildContext context) async {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: ConfirmDialog(
                  width: 297,
                  height: 240,
                  image: 'assets/images/sad_face.png',
                  title: 'Are you sure to delete this booking?',
                  callbackConfirm: deleteBooking,
                )),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  _buildBookingStatus(bookingStatus) {
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

  Future<ConfirmAction> _asyncCancelledDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ConfirmDialog(
          width: 297,
          height: 310,
          image: 'assets/images/x_icon.png',
          headline: 'Booking cancelled.',
          callbackDone: back,
        );
      },
    );
  }

  cancelBooking() async {
    try {
      final res = await dataService.cancelBooking(booking.id);
      _asyncCancelledDialog(context);
    } catch (err) {
      Reusable.showTotastError(err.message);
    }
  }

  deleteBooking() async {
    try {
      final res = await dataService.deleteBooking(booking.id);
      bottomNavBarBloc.pickItem(PageIndex.BOOKING_LIST, {'previousStatus': widget.previousStatus});
    } catch (err) {
      Reusable.showTotastError(err.message);
    }
  }

  back() {
    // Navigator.of(context).pop(false);
    bottomNavBarBloc.pickItem(PageIndex.BOOKING_LIST, {'previousStatus': widget.previousStatus});
  }

  _openCall() {
    if (booking.contactPhone != null) {
      launch("tel://" + booking.contactPhone);
    }
  }

  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await deviceCalendar.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await deviceCalendar.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await deviceCalendar.retrieveCalendars();
      if (calendarsResult?.data != null) {
        _calendars = calendarsResult?.data;
        for (var ca in _calendars) {
          if (!ca.isReadOnly) {
            setState(() {
              _selectedCalendar = ca;
            });
            break;
          }
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  _addBookingToCalendarEvent() async {
    if (_selectedCalendar != null) {
      Result<String> response = await deviceCalendar.createOrUpdateEvent(
        Event(
          _selectedCalendar.id,
          title: booking.offerName,
          description: booking.addressFulfillment ?? '',
          start: Booking.getBookingDateFull(booking.bookingDate),
          end: Booking.getBookingDateFull(booking.bookingDate),
        ),
      );
      if (response.data != null) {
       _showMessageDialog(true, "Booking added to calendar!");
      }
    } else {
      _showMessageDialog(false, "No calendar available !");
    }
  }

  _showMessageDialog(success, text) {
    containerForSheet<String>(
        context: context,
        child: Container(
          child: MessagePopup(success: success, title1: text),
        ));
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop();
          });
          return child;
        }).then<void>((T value) {
      // Navigator.pop(context);
    });
  }
}
