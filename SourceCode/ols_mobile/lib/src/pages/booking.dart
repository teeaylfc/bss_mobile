import 'package:ols_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/models/booking_model.dart';
import 'package:ols_mobile/src/models/store_model.dart';
import 'package:ols_mobile/src/pages/booking_detail.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/notification_popup.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:ols_mobile/src/widgets/section_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sticky_headers/sticky_headers.dart';

class BookingPage extends StatefulWidget {
  final couponId;
  final List<Store> listStores;
  final String merchantName;
  final BitmapDescriptor markerIcon;
  final Booking booking;

  BookingPage({this.couponId, this.merchantName, this.listStores, this.markerIcon, this.booking});

  @override
  State<StatefulWidget> createState() {
    return _BookingPageState();
  }
}

class _BookingPageState extends State<BookingPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DataService dataService = DataService();

  GoogleMapController mapController;

  DateTime date;

  TextEditingController _quantityChildrenController = TextEditingController();
  TextEditingController _quantityAdultController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _bookingTimeController;

  DateTime bookTime;
  DateTime bookDate;
  int quantityAdult;
  int quantityChildren = 0;
  int selectedStore = 0;
  bool loading = false;
  double latitude;
  double longitude;
  Set<Marker> markers = Set();

  void _onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    _bookingTimeController = TextEditingController();
    if (widget.booking != null) {
      bookDate = Booking.getBookingDateFull(widget.booking.bookingDate);
      bookTime = Booking.getBookingDateFull(widget.booking.bookingDate);
      _bookingTimeController.text = DateFormat.jm().format(bookTime);
      if (widget.booking.quantityAdult != null) {
        _quantityAdultController.text = widget.booking.quantityAdult.toString();
        quantityAdult = widget.booking.quantityAdult;
      }
      if (widget.booking.quantityChildren != null) {
        _quantityChildrenController.text = widget.booking.quantityChildren.toString();
        quantityChildren = widget.booking.quantityChildren;
      }
      if (widget.booking.note != null) {
        _noteController.text = widget.booking.note;
      }
      selectedStore = widget.booking.fulfillmentPartnerId;
    } else {
      bookDate = DateTime.now();
      quantityAdult = 0;
      quantityChildren = 0;
    }

    _initMap();
  }

  _initMap() {
    if (widget.listStores != null && widget.listStores.length > 0) {
      latitude = widget.listStores[0].latitude;
      longitude = widget.listStores[0].longitude;

      for (int i = 0; i < widget.listStores.length; i++) {
        Store store = widget.listStores[i];
        Marker resultMarker = Marker(
          markerId: MarkerId(store.storeId),
          icon: widget.markerIcon,
          infoWindow: InfoWindow(title: store.storeName, snippet: store.address),
          position: LatLng(store.latitude != null ? store.latitude : 0, store.longitude != null ? store.longitude : 0),
        );
        // Add it to Set
        markers.add(resultMarker);
      }
    }
  }

  @override
  void didUpdateWidget(BookingPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.booking != null) {
      _onSelectStore(widget.booking.fulfillmentPartnerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: new AppBar(
            iconTheme: IconThemeData(color: CommonColor.textRed),
            backgroundColor: Colors.white,
            elevation: 0.5,
            title: Text(widget.merchantName ?? ''),
            automaticallyImplyLeading: widget.booking == null,
            leading: IconButton(
              icon: (Icon(Icons.arrow_back_ios)),
              onPressed: () {
                bottomNavBarBloc.pickItem(PageIndex.BOOKING_LIST, {'previousStatus' : "COMING"});
              },
            )),
        body: ListView(
          children: <Widget>[
            // Map
            StickyHeader(
              header: Container(
                width: MediaQuery.of(context).size.width,
                height: ScreenUtil().setSp(200),
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude ?? 0, longitude ?? 0),
                    zoom: 15,
                  ),
                  markers: markers,
                  onMapCreated: _onMapCreated,
                ),
              ),
              content: Column(
                children: <Widget>[
                  SectionTitle('Select booking date', null, EdgeInsets.fromLTRB(20, 10, 20, 0)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: ScreenUtil().setSp(150),
                    child: CalendarCarousel<Event>(
                      onDayPressed: (DateTime date, List<Event> events) {
                        this.setState(() => bookDate = date);
                      },
                      weekendTextStyle: TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(15), fontFamily: 'Tahoma'),
                      selectedDayTextStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, fontFamily: 'Tahoma'),
                      headerTextStyle: TextStyle(fontSize: ScreenUtil().setSp(20), color: Color(0xFFF76016), fontFamily: 'Tahoma'),
                      prevDaysTextStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(15), fontFamily: 'Tahoma'),
                      weekdayTextStyle: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(15), fontFamily: 'Tahoma'),
                      selectedDateTime: bookDate,
                      todayButtonColor: Colors.green,
                      todayBorderColor: Colors.green,
                      staticSixWeekFormat: true,
                      weekFormat: true,
                      showWeekDays: true,
                      selectedDayButtonColor: CommonColor.textRed,
                      selectedDayBorderColor: CommonColor.textRed,
                      iconColor: CommonColor.textRed,
                      showHeaderButton: true,
                      minSelectedDate: DateTime.now().add(Duration(days: -1)),
                      headerTitleTouchable: true,
                      customGridViewPhysics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                  Divider(color: Color(0xffE7E7E7)),
                  SectionTitle('Select booking time', null, EdgeInsets.fromLTRB(20, 10, 20, 10)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[_buildBookingTimeInput()],
                    ),
                  ),
                  Divider(color: Color(0xffE7E7E7)),
                  _buildItem('Adults', true, _quantityAdultController),
                  _buildItem('Children', false, _quantityChildrenController),
                  Divider(color: Color(0xffE7E7E7)),
                  _buildLocation(context, widget.listStores),
                  Divider(color: Color(0xffE7E7E7)),
                  _buildNote(),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setSp(40)),
            Container(
              height: ScreenUtil().setSp(74),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Color(0xFFD6D6D6),
                  blurRadius: 1.0,
                ),
              ]),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: _buildGetButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildLocation(context, List<Store> listStores) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select Location',
            style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: listStores != null
                ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listStores.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/images/store.png'),
                              height: ScreenUtil().setSp(15),
                            ),
                            SizedBox(
                              width: ScreenUtil().setSp(10),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.8,
                              child: Text(listStores[index].storeName + ' - ' + listStores[index].address,
                                  maxLines: 4, style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500)),
                            ),
                            Spacer(),
                            Radio(
                              value: listStores[index].storeId,
                              onChanged: _onSelectStore,
                              groupValue: selectedStore,
                              activeColor: CommonColor.textRed,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                })
                : Container(),
          ),
        ],
      ),
    );
  }

  _onSelectStore(val) {
    setState(() {
      selectedStore = val;
    });
    markers.forEach((m) {
      if (val.toString() == m.markerId.value) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(m.position.latitude, m.position.longitude), zoom: 15.0),
          ),
        );
      }
    });
  }

  _buildGetButton(context) {
    return RaisedGradientButton(
        child: Text(
          widget.booking == null ? 'Book' : 'Update',
          style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
        ),
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)],
        ),
        height: ScreenUtil().setSp(40),
        borderRadius: 30,
        onPressed: () {
          book();
        });
  }

  _buildItem(title, type, controller) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: CommonColor.textBlack, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              _decreasePerson(type);
            },
            child: Icon(
              Icons.remove_circle_outline,
              color: CommonColor.textRed,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
            width: ScreenUtil().setSp(50),
            child: TextField(
                textAlign: TextAlign.center,
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE7E7E7))))),
          ),
          SizedBox(
            width: ScreenUtil().setSp(20),
          ),
          GestureDetector(
            onTap: () {
              _increasePerson(type);
            },
            child: Icon(
              Icons.add_circle_outline,
              color: CommonColor.textRed,
            ),
          ),
        ],
      ),
    );
  }

  _buildBookingTimeInput() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _showTimePicker(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: new TextField(
            onTap: () {
              _showTimePicker(context);
            },
            decoration: InputDecoration(
                hintText: "Time",
                suffixIcon: GestureDetector(
                  child: Icon(
                    Icons.access_time,
                    color: Color(0xFFA9A9A9),
                  ),
                ),
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
            maxLines: 1,
            enabled: false,
            controller: _bookingTimeController),
      ),
    );
  }

  _showTimePicker(BuildContext context) {
    new Picker(
        adapter: new DateTimePickerAdapter(
          type: PickerDateTimeType.kHM_AP,
        ),
        textAlign: TextAlign.right,
        selectedTextStyle: TextStyle(color: Colors.orange, fontSize: ScreenUtil().setSp(24)),
        textStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: ScreenUtil().setSp(24)),
        delimiter: [
          PickerDelimiter(
              column: 5,
              child: Container(
                width: ScreenUtil().setSp(16),
                alignment: Alignment.center,
                child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
                color: Colors.white,
              ))
        ],
        confirmTextStyle: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(20)),
        cancelTextStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: ScreenUtil().setSp(20)),
        footer: Container(
          height: ScreenUtil().setSp(100),
          alignment: Alignment.center,
        ),
        onConfirm: (Picker picker, List value) {
          bookTime = (picker.adapter as DateTimePickerAdapter).value;

          _bookingTimeController.text = DateFormat.jm().format(bookTime);
        },
        onSelect: (Picker picker, int index, List<int> selecteds) {
          this.setState(() {
            // _bookingTimeController.value = new TextEditingController.fromValue(new TextEditingValue(text: picker.adapter.toString())).value;
          });
        }).showModal(context);
  }

  _buildNote() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Note',
            style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _noteController,
                maxLines: 5,
                onSaved: (value) => {},
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xFFE7E7E7))))),
          ),
        ],
      ),
    );
  }

  _increasePerson(type) {
    if (type) {
      quantityAdult++;
      setState(() {
        _quantityAdultController.text = quantityAdult.toString();
      });
    } else {
      quantityChildren++;
      setState(() {
        _quantityChildrenController.text = quantityChildren.toString();
      });
    }
  }

  _decreasePerson(type) {
    if (type) {
      if (quantityAdult > 0) {
        quantityAdult--;
        setState(() {
          _quantityAdultController.text = quantityAdult.toString();
        });
      }
    } else {
      if (quantityChildren > 0) {
        quantityChildren--;
        setState(() {
          _quantityChildrenController.text = quantityChildren.toString();
        });
      }
    }
  }

  void book() async {
    try {
      if (bookDate == null) {
        Reusable.showTotastError("Please select booking date");
        return;
      }
      // if (bookDate.isBefore(DateTime.now())) {
      //   _showError("Booking date can not be in past");
      // }
      if (bookTime == null) {
        Reusable.showTotastError("Please select booking time");
        return;
      }
      if (quantityAdult <= 0 && quantityChildren <= 0) {
        Reusable.showTotastError("Please select number of people");
        return;
      }
      if (quantityAdult <= 0 && quantityChildren <= 0) {
        Reusable.showTotastError("Please select number of people");
        return;
      }
      if (selectedStore == null || selectedStore <= 0) {
        Reusable.showTotastError("Please select location");
        return;
      }
      DateTime bookingDate = DateTime(bookDate.year, bookDate.month, bookDate.day, bookTime.hour, bookTime.minute);
      String bookingDateStr = DateFormat('MM/dd/yyyy HH:mm:ss').format(bookingDate);
      setState(() {
        loading = true;
      });
      if (widget.booking == null) {
        Booking booking = await dataService.book(widget.couponId, selectedStore, bookingDateStr, quantityAdult, quantityChildren, _noteController.text);
        if (booking != null) {
          setState(() {
            loading = false;
          });
          _showMessageDialog(true, 'Booking has been settled.', booking.id.toString());
        }
      } else {
        Booking booking = await dataService.editBooking(
            widget.booking.id, widget.couponId, selectedStore, bookingDateStr, quantityAdult, quantityChildren, _noteController.text);
        if (booking != null) {
          setState(() {
            loading = false;
          });
          _showMessageDialog(true, 'Booking has been updated.', booking.id.toString());
        }
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      Reusable.showTotastError(error.message);
    }
  }

  _showMessageDialog(success, text, ogbjectId) {
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
            Navigator.pop(context);
          });
          bottomNavBarBloc.pickItem(PageIndex.BOOKING_LIST,{"previousStatus" : "COMING"});
          return child;
        }).then<void>((T value) {
    });
  }

}
