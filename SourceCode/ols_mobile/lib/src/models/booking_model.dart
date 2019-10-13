import 'package:ols_mobile/src/models/pageable_model.dart';
import 'package:ols_mobile/src/models/store_model.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingList extends Pageable {
  final bool last;
  final List<Booking> content;

  BookingList(this.content, this.last);
  factory BookingList.fromJson(Map<String, dynamic> json) => _$BookingListFromJson(json);
}

@JsonSerializable()
class Booking {
  final int id;
  final int offerImage;
  final String bookingDate;
  final int offerId;
  final int fulfillmentPartnerId;
  final String offerName;
  final String addressFulfillment;
  final String storeName;
  final String bookingStatus;
  final String contactName;
  final String contactPhone;
  final double storeLongitude;
  final double storeLatitude;
  final List<Store> listStores;
  final int quantityAdult;
  final int quantityChildren;
  final String note;

  Booking(
      {this.id,
      this.bookingDate,
      this.offerId,
      this.offerImage,
      this.fulfillmentPartnerId,
      this.offerName,
      this.addressFulfillment,
      this.storeName,
      this.bookingStatus,
      this.contactName,
      this.contactPhone,
      this.storeLatitude,
      this.storeLongitude,
      this.quantityAdult,
      this.quantityChildren,
      this.note,
      this.listStores});

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

  static getBookingDate(date) {
    if (date != null) {
      DateTime d = DateFormat("MM/dd/yyyy", "en_US").parse(date);
      return DateFormat("MM.dd.yyyy").format(d);
    }
    return null;
  }

  static getBookingTime(date) {
    if (date != null) {
      DateTime d = DateFormat("MM/dd/yyyy HH:mm", "en_US").parse(date);
      return DateFormat("HH:mm").format(d).toString() + ' - ' + DateFormat('EEEE').format(d).toString();
    }
    return null;
  }

  static getBookingDateFull(date) {
    if (date != null) {
      DateTime d = DateFormat("MM/dd/yyyy HH:mm", "en_US").parse(date);
      return d;
    }
    return null;
  }
}

