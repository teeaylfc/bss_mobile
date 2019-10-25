import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/http_client.dart';
import 'package:ols_mobile/src/models/account_info_model.dart';
import 'package:ols_mobile/src/models/balance_detail_model.dart';
import 'package:ols_mobile/src/models/booking_model.dart';
import 'package:ols_mobile/src/models/branch_model.dart';
import 'package:ols_mobile/src/models/category_model.dart';
import 'package:ols_mobile/src/models/item_cms_model.dart';
import 'package:ols_mobile/src/models/item_detail_model.dart';
import 'package:ols_mobile/src/models/item_model.dart';
import 'package:ols_mobile/src/models/list_item_model.dart';
import 'package:ols_mobile/src/models/list_redeem_history_model.dart';
import 'package:ols_mobile/src/models/list_review_model.dart';
import 'package:ols_mobile/src/models/list_transaction_model.dart';
import 'package:ols_mobile/src/models/notification_model.dart';
import 'package:ols_mobile/src/models/store_model.dart';
import 'package:ols_mobile/src/models/wallet_model.dart';

enum TOP_TYPE { BOOKED, REDEEMED, VIEWED, SEARCHED, REVIEWED, RATING }

class DataService {
  final String _cywEndpoint = cywApiUrl;
  final String _apiEndpoint = apiUrl;
  final String _baseEndpoint = baseApiUrl;
  final String _apiUpload = fileApiUpload;
  final String _mbfEndpoint = mbfApiUrl;
  final String _baseApiBss = baseApiBss;
  
  final size = Config.PAGE_SIZE;


  Future<dynamic> getCity () async{
     final response = await httpManager.get('$_baseApiBss'+'location/city', null);
     return response;
  }

  Future<AccountInfo> register(email,fullName,phone,gender,password )async{
    final body = {
      "email":email,
      "fullName":fullName,
      "phone":phone,
      "gender":gender,
      "password": password
    };
    final response = await httpManager.post('$_baseApiBss'+'users/register', body);
    return AccountInfo.fromJson(response['data']);
  }


    Future<AccountInfo> upLoadAvatar(File file) async {
    FormData formData = FormData();
    formData.add("file", UploadFileInfo(file, "filename"));
    final response = await httpManager.put('$_baseApiBss'+'users/update/image', formData);
    return AccountInfo.fromJson(response['data']['accountInfo']);
  }

























  Future<dynamic> checkEmailExist(email) async {
    final response = await httpManager.get('$_cywEndpoint/customer/$distributorId?email=$email', null);
    return (response['data']);
  }

  Future<AccountInfo> updateProfile(fullName,phone, gender) async {
    final dataJson = {"fullName": fullName,"phone": phone, "gender": gender};
    final response = await httpManager.put('$_baseApiBss'+'users/update', dataJson);
    return AccountInfo.fromJson(response['data']['accountInfo']);
  }

  Future<bool> isFirstPassword() async {
    final response = await httpManager.get('$_cywEndpoint/check-login/password_default', null);
    return (response['data']);
  }

  Future<dynamic> changePassword(oldPassword, newPassword) async {
    final body = {"newPassword": newPassword, "oldPassword": oldPassword};
    final response = await httpManager.post('$_baseEndpoint' + 'api/mobile/cyw/customer/change_password', body);
    return (response['data']);
  }

  Future<String> forgotPasswordInit(email) async {
    final body = {"distributorId": "$distributorId", "email": "$email"};
    final response = await httpManager.post('$_baseEndpoint' + 'api_mobile/customer/reset_password/init', body);
    return (response['data']);
  }

  Future<String> forgotPasswordFinish(email, key, newPassword) async {
    final body = {"distributorId": "$distributorId", "email": "$email", "key": "$key", "newPassword": "$newPassword"};
    final response = await httpManager.post('$_baseEndpoint' + 'api_mobile/customer/reset_password/finish', body);
    return (response['data']);
  }

  Future<ListItem> getHotItem(page) async {
    final response = await httpManager.get('$_mbfEndpoint/items/hot?page=$page&size=$size', null);
    return ListItem.fromJson(response);
  }

  //upload Avatar for EditProfile page


  Future<ListItem> getNewestItem(page) async {
    final response = await httpManager.get('$_mbfEndpoint/items/newest?page=$page&size=$size', null);
    return ListItem.fromJson(response);
  }

  Future<ListItem> getFavoritesItem(page) async {
    final response = await httpManager.get('$_mbfEndpoint/items/my-favorites?page=$page&size=$size', null);
    return ListItem.fromJson(response);
  }

    Future<ListMyReward> getMyReward(page) async {
    final response = await httpManager.get('$_mbfEndpoint/my-rewards?lang=en&page=$page&size=$size', null);
    return ListMyReward.fromJson(response);
  }

  Future<int> countWallet() async {
    final response = await httpManager.get('$_apiEndpoint/customer/offer_count_in_wallet', null);
    return (response['data']);
  }

  // Soon Expire Item
  Future<ListItem> getExpireSoon(page) async {
    var requestUrl = '$_mbfEndpoint/items/soon-expire?page=$page&size=$size';
    final response = await httpManager.get(requestUrl, null);
    return ListItem.fromJson(response);
  }

  Future<ListReview> getListReview(companyId, page) async {
    final response = await httpManager.get('$_cywEndpoint/reviews/company/$distributorId/$companyId?page=$page&size=$size', null);
    return ListReview.fromJson(response['data']);
  }

  // My Item for home page
  Future<ListItem> getViewNearlyItem(page) async {
    final response = await httpManager.get('$_mbfEndpoint/items/view-nearly?page=$page&size=$size', null);
    return ListItem.fromJson(response);
  }

  //Get listFavoriteItem for profile page
  Future<ListItem> getFavorites() async {
    final response = await httpManager.get('$_cywEndpoint/offers/your_favorite/$distributorId', null);
    return ListItem.fromJson(response['data']);
  }

  //  Get all category
  Future<CategoryList> getAllCategory() async {
    var response = await httpManager.get('$_mbfEndpoint/categories?lang=vi', null);
    print(response);
    return CategoryList.fromJson(response);
  }

  // Get Item by category
  Future<ListItem> getItemByCategory(categoryCode, page) async {
    final size = Config.PAGE_SIZE;
    final response = await httpManager.get('$_mbfEndpoint/categories/$categoryCode/items?page=$page&size=$size', null);
    return ListItem.fromJson(response);
  }

  //  Get all category
  Future<List<Category>> getBrowserCategory(page) async {
    final response = await httpManager.get('$_mbfEndpoint/items/group-category', null);
    print(response);
    List<Category> categories = (response as List).map((model) => Category.fromJson(model)).toList();
    return categories;
  }

  // Get Item detail
  Future<Item> getItemDetail(itemCode) async {
    final response = await httpManager.get('$_mbfEndpoint/items/$itemCode', null);
    return Item.fromJson(response);
  }

  // Get top for home page
  Future<ListItem> getInterestingItem(page) async {
    final size = Config.PAGE_SIZE;
    final response = await httpManager.get('$_mbfEndpoint/items/interesting?page=$page&size=$size', null);
    return ListItem.fromJson(response);
  }
  Future<dynamic> getQrCode(voucherCode) async{
    final response = await httpManager.get('$_mbfEndpoint/rewards/$voucherCode/qrCode', null);
    return response;
  }

  Future<ListItem> getListItemBookingRewards(status, page) async {
    final size = Config.PAGE_SIZE;
    final response = await httpManager.get('$_cywEndpoint/offers/explore/$distributorId/$status?page=$page&size=$size', null);
    return ListItem.fromJson(response['data']);
  }

  Future<dynamic> addOffersToWallet(offerIds) async {
    final jsonRequest = {'distributorId': distributorId, 'offerIds': offerIds};
    final response = await httpManager.put('$_apiEndpoint/customer/wallet', jsonRequest);
    return response['data'];
  }

  Future<dynamic> removeItemFromWallet(ItemId, status) async {
    final response = await httpManager.post('$_apiEndpoint/customer/remove_wallet/$distributorId/$ItemId/$status', null);
    return response['data'];
  }

  // Pay at table
  Future<dynamic> payAtTable(offerIds, qrcode) async {
    final jsonRequest = {'distributorId': distributorId, 'offerIds': offerIds, 'qr': qrcode.toString()};

    print(jsonRequest.toString());
    final response = await httpManager.post('$_baseEndpoint/api/redeem_pay_at_table', jsonRequest);
    return response['data'];
  }

  Future<dynamic> receiptDataCertificate(qrCode) async {
    final dataJson = {"qr": qrCode};
    final response = await httpManager.post('$_apiEndpoint/customer/receipt_certificate/', dataJson);
    return response['data'];
  }

  // End transaction pay at table
  Future<dynamic> receiptDataCertificatePayAtTable(qrCode) async {
    final dataJson = {"qr": qrCode};
    final response = await httpManager.post('$_baseEndpoint/api/redeem_pay_at_table_end_offline', dataJson);
    return response['data'];
  }

  // write comment & rating
  Future<Review> writeComment(companyId, rate, tittle, review) async {
    final jsonRequest = {'companyId': companyId, 'tittle': tittle, 'rate': rate, 'review': review};
    final response = await httpManager.post('$_cywEndpoint/reviews/$distributorId', jsonRequest);
    return Review.fromJson(response);
  }

  // like Item
  Future<Item> likeItem(itemCode) async {
    final response = await httpManager.post('$_mbfEndpoint/items/$itemCode/favorites', null);
    return Item.fromJson(response);
  }

  // like Item
  Future<Branch> likeBranch(brancheId) async {
    final response = await httpManager.post('$_mbfEndpoint/branches/$brancheId/favorites', null);
    return Branch.fromJson(response);
  }

   // like Item
  Future<Store> likeStore(storeId) async {
    final response = await httpManager.post('$_mbfEndpoint/stores/$storeId/favorites', null);
    return Store.fromJson(response);
  }

  // booking
  Future<Booking> book(ItemId, fulfillmentPartnerId, bookingDate, quantityAdult, quantityChildren, String note) async {
    final jsonRequest = {
      'offerId': ItemId,
      'fulfillmentPartnerId': fulfillmentPartnerId,
      'bookingDate': bookingDate.toString(),
      'quantityAdult': quantityAdult,
      'quantityChildren': quantityChildren,
      'note': note.toString()
    };

    final response = await httpManager.post('$_cywEndpoint/bookings/$distributorId', jsonRequest);
    return Booking.fromJson(response['data']);
  }

  // edit booking
  Future<Booking> editBooking(id, ItemId, fulfillmentPartnerId, bookingDate, quantityAdult, quantityChildren, String note) async {
    final jsonRequest = {
      'id': id,
      'offerId': ItemId,
      'fulfillmentPartnerId': fulfillmentPartnerId,
      'bookingDate': bookingDate.toString(),
      'quantityAdult': quantityAdult,
      'quantityChildren': quantityChildren,
      'note': note.toString()
    };

    final response = await httpManager.put('$_cywEndpoint/bookings/$distributorId', jsonRequest);
    return Booking.fromJson(response['data']);
  }

  // get booking list for consumer
  Future<BookingList> getBooking(page, status) async {
    final response = await httpManager.get('$_cywEndpoint/bookings/consumer/$distributorId/$status/?page=$page&size=$size', null);
    return BookingList.fromJson(response['data']);
  }

  // get booking detail
  Future<Booking> getBookingDetai(id) async {
    final response = await httpManager.get('$_cywEndpoint/bookings/$id', null);
    return Booking.fromJson(response['data']);
  }

  // cancel booking
  Future<dynamic> cancelBooking(id) async {
    final response = await httpManager.put('$_cywEndpoint/bookings/cancel-consumer/$id', null);
    return response['data'];
  }

  // delete booking
  Future<dynamic> deleteBooking(id) async {
    final response = await httpManager.delete('$_cywEndpoint/bookings/$id', null);
    return response['data'];
  }

  Future<dynamic> selectItemOffline(offerIds, storeId) async {
    final response = await httpManager.post('$_apiEndpoint/customer/select_offers_offline/$distributorId/$storeId', offerIds);
    return response['data'];
  }

  // Search Item
  Future<ListItem> search(keyword, page) async {
    final response = await httpManager.get('$_mbfEndpoint/items?query=$keyword&page=$page', null);
    return ListItem.fromJson(response);
  }

  // Search history
  Future<dynamic> searchHistory() async {
    final response = await httpManager.get('$_apiEndpoint/customer/search_history', null);
    return response['data'];
  }

  // Clear search history
  Future<dynamic> clearSearchHistory() async {
    final response = await httpManager.delete('$_apiEndpoint/customer/search_history', null);
    return response['data'];
  }

  // Search suggestion
  Future<dynamic> searchSuggestion(keyword, limit) async {
    final response = await httpManager.get('$_cywEndpoint/customer/search_suggestion_history?limit=$limit&keyword=$keyword', null);
    print(response['data']);
    return response['data'];
  }

  // get Transaction History
  Future<ListTransaction> getTransactionHistory(page, fromDate, toDate) async {
    final response = await httpManager.get('$_mbfEndpoint/transaction-history?fromDate=$fromDate&toDate=$toDate&lang=vi&page=$page', null);
    return ListTransaction.fromJson(response);
  }

  Future<ListRedeemHistory> getListRedeemHistory(page, fromDate, toDate) async{
    final response = await httpManager.get('$_mbfEndpoint/redeem-history?fromDate=$fromDate&toDate=$toDate&lang=vi&page=$page', null);
    return ListRedeemHistory.fromJson(response);
  }

  // get Transaction History detail
  Future<Transaction> getTransactionHistoryDetail(id) async {
    final response = await httpManager.get('$_cywEndpoint/customer/transaction_history/$id', null);
    return Transaction.fromJson(response['data']);
  }

  Future<dynamic> registerDevice(os, osVersion, tokenId, deviceName) async {
    var jsonRequest = {
      'os': os,
      'osVersion': osVersion,
      'tokenId': tokenId,
      'deviceName': deviceName,
    };
    final response = await httpManager.post('$_apiEndpoint/customer/device', jsonRequest);
    return response;
  }

  Future<dynamic> deleteDevice(tokenId) async {
    var jsonRequest = {
      'tokenId': tokenId,
    };
    final response = await httpManager.delete('$_apiEndpoint/customer/device', jsonRequest);
    return response;
  }

  // Pay at table
  Future<dynamic> redeemAtTable(offerIds, qrcode) async {
    final jsonRequest = {'distributorId': distributorId, 'offerIds': offerIds, 'qr': qrcode.toString()};

    print(jsonRequest.toString());
    final response = await httpManager.post('$_baseEndpoint/api/redeem_pay_at_table', jsonRequest);
    return response;
  }

  Future<ListItem> filterWallets(page, ItemType, storeId, brandId, distance, latitude, longitude) async {
    var jsonRequest = {};
    final response = await httpManager.post('$_apiEndpoint/customer/filter_wallet/$distributorId?page=$page&size=$size', jsonRequest);

    return ListItem.fromJson(response['data']['pagesInfo']);
  }

  // get Notification
  Future<ListMobileNotification> getNotification(page) async {
    final response = await httpManager.get('$_mbfEndpoint/user/notifications?page=$page&size=$size', null);
    return ListMobileNotification.fromJson(response);
  }

  // count notification
  Future<dynamic> countNotification() async {
    final response = await httpManager.get('$_apiEndpoint/customer/notifications/count', null);
    return response['data'];
  }

  // delete Notification
  Future<dynamic> deleteNotification(notificationIds) async {
    final response = await httpManager.delete('$_mbfEndpoint/user/notifications', notificationIds);
    return response;
  }

  // update Notification
  Future<dynamic> updateNotificationStatus(id) async {
    final response = await httpManager.put('$_apiEndpoint/customer/notifications/status/$id', null);
    return response['data'];
  }

  // Get user balance
  Future<AccountInfo> getBalance() async {
    final response = await httpManager.get('$_mbfEndpoint/account/balance', null);
    return AccountInfo.fromJson(response);
  }
  Future<BalanceDetail> getBalanceDetail() async {
    final response = await httpManager.get('$_mbfEndpoint/account/balance', null);
    return  BalanceDetail.fromJson(response['balanceDetail']);
  }

  Future<bool> prepareCheckout(itemCodeList) async{
    final response = await httpManager.post('$_mbfEndpoint/cart/checkout/prepare', itemCodeList);
    return response['needShippingAddress'];
  }
  Future<dynamic>checkoutCart(itemCodeList, shippingAddress) async{
    final body = {
      "item" : itemCodeList,
      "shippingAddress" : shippingAddress
    };
    final response = await httpManager.post('$_mbfEndpoint/cart/checkout', body);
    return response;
  }

  // Get branch list
  Future<ListStore> getStore(page, bool favorites) async {
    String url = '$_mbfEndpoint/stores?page=$page&size=$size';
    if (favorites) {
      url = '$_mbfEndpoint/stores/my-favorites?page=$page&size=$size';
    }
    final response = await httpManager.get(url, null);
    return ListStore.fromJson(response);
  }
  Future<ListStore> getAllStore(page) async {
    String url = '$_mbfEndpoint/stores?page=$page&size=$size';
    final response = await httpManager.get(url, null);
    return ListStore.fromJson(response);
  }
  Future<ListStore> getFavoriteStore(page) async {
    String url = '$_mbfEndpoint/stores/my-favorites?page=$page&size=$size';
    final response = await httpManager.get(url, null);
    return ListStore.fromJson(response);
  }

  // Get branch detail
  Future<Store> getStoreDetail(storeId) async {
    final response = await httpManager.get('$_mbfEndpoint/stores/$storeId', null);
    return Store.fromJson(response);
  }

  // Get store item
  Future<ListItem> getStoreItem(storeId) async {
    final response = await httpManager.get('$_mbfEndpoint/stores/$storeId/items', null);
    return ListItem.fromJson(response);
  }


  Future<ListBranch> getBranch(page) async {
    String url = '$_mbfEndpoint/branches?page=$page&size=$size';
    final response = await httpManager.get(url, null);
    return ListBranch.fromJson(response);
  }
  Future<OrderList> addCartAfterLogin(jsonRequest) async {
    final response = await httpManager.post('$_mbfEndpoint/cart/sync', jsonRequest);
    return OrderList.fromJson(response);
  }
  Future<OrderList> getListCart() async {
    final response = await httpManager.get('$_mbfEndpoint/cart', null);
    return OrderList.fromJson(response);
  }
  Future<OrderList> removeCart(itemCode) async {
    final response = await httpManager.post('$_mbfEndpoint/cart/$itemCode/remove', null);
    return OrderList.fromJson(response);
  }
  Future<OrderList> addOrUpdateCart(itemCode, jsonRequest) async {
    print("jsonRequest: $jsonRequest");
    final response = await httpManager.post('$_mbfEndpoint/cart/$itemCode', jsonRequest);
    return OrderList.fromJson(response);
  }
  Future<ItemCms> getCmsFaq(lang, page) async {
    final response = await httpManager.get('$_mbfEndpoint/cms/faq?lang=$lang&page=$page&size=$size', null);
    return ItemCms.fromJson(response);
  }
  Future<ItemCms> getCmsTac(lang, page) async {
    final response = await httpManager.get('$_mbfEndpoint/cms/tac?lang=$lang&page=$page&size=$size', null);
    return ItemCms.fromJson(response);
  }
  Future<ItemCms> getCmsAboutMbf(lang, page) async {
    final response = await httpManager.get('$_mbfEndpoint/cms/about?lang=$lang&page=$page&size=$size', null);
    return ItemCms.fromJson(response);
  }
  Future<dynamic> sendFeedback(jsonRequest) async {
    final response = await httpManager.post('$_mbfEndpoint/feedback', jsonRequest);
    return response;
  }
}
