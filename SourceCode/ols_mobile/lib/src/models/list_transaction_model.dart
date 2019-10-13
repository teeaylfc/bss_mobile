import 'package:json_annotation/json_annotation.dart';
import 'package:ols_mobile/src/models/pageable_model.dart';

part 'list_transaction_model.g.dart';

@JsonSerializable()
class ListTransaction extends Pageable {
  final List<Transaction> content;
  final bool last;

  ListTransaction({this.content, this.last});

  factory ListTransaction.fromJson(Map<String, dynamic> json) => _$ListTransactionFromJson(json);
}

@JsonSerializable()
class Transaction {
  final double netAmount;
  final double discountAmount;
  final double grossAmount;
  final int transactionId;
  final double awardAmount;
  final double point;

  final String txnType;
  final String description;
  final String subject;
  final String storeAddress;
  final int storeImage;
  final String txnDatetime;
  final List<CouponTransaction> offerRedeems;

  Transaction(this.transactionId, this.netAmount, this.discountAmount, this.grossAmount, this.description, this.subject, this.storeAddress, this.storeImage,
      this.txnDatetime, this.offerRedeems, this.awardAmount,this.point,this.txnType);

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

@JsonSerializable()
class CouponTransaction {
  final int offerId;
  final String offerName;
  final String companyName;
  final int image;
  final int quantity;
  const CouponTransaction(this.offerId, this.offerName, this.companyName, this.image, this.quantity);

  factory CouponTransaction.fromJson(Map<String, dynamic> json) => _$CouponTransactionFromJson(json);
}
