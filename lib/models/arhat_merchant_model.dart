class CustomMerchantModel {
  final String? id;
  final String? merchantName;
  final String? merchantAddress;
  final double? merchantContact;
  final String? productName;
  final double? productQuantity;
  final String? productQuantityType;
  final String? storeNo;
  final String? roomNo;
  final double? storeRent;
  final String? truckId;
  final double? truckQuantity;
  final double? truckRent;
  final double? totalWeight;
  final double? costPerWeight;
  final double? commission;
  final String? productId;
  final String? datetime;
  final bool? paymentStatus;
  final double? commissionAmount;
  final double? mazduri;
  final double? totalSale;
  final double? sellingProfit;
  // Changed to bool

  CustomMerchantModel({
    this.id,
    this.merchantName,
    this.merchantAddress,
    this.merchantContact,
    this.productName,
    this.productQuantity,
    this.productQuantityType,
    this.storeNo,
    this.roomNo,
    this.storeRent,
    this.truckId,
    this.truckQuantity,
    this.truckRent,
    this.totalWeight,
    this.costPerWeight,
    this.commission,
    this.productId,
    this.datetime,
    this.paymentStatus,
    this.commissionAmount,
    this.mazduri,
    this.totalSale,
    this.sellingProfit, // Changed to bool
  });

  factory CustomMerchantModel.fromMap(String id, Map<String, dynamic> data) {
    return CustomMerchantModel(
      id: id,
      merchantName: data['merchantName'] ?? '',
      merchantAddress: data['merchantAddress'] ?? '',
      merchantContact: data['merchantContact'] ?? 0,
      productName: data['productName'] ?? '',
      productQuantity: data['productQuantity'] ?? 0,
      productQuantityType: data['productQuantityType'] ?? '',
      storeNo: data['storeNo'] ?? '',
      roomNo: data['roomNo'] ?? '',
      storeRent: data['storeRent'] ?? 0,
      truckId: data['truckId'] ?? '',
      truckQuantity: data['truckQuantity'] ?? 0,
      truckRent: data['truckRent'] ?? 0,
      totalWeight: data['totalWeight'] ?? 0,
      costPerWeight: data['costPerWeight'] ?? 0,
      commission: data['commission'] ?? 0,
      productId: data['productId'] ?? '',
      datetime: data['datetime'],
      paymentStatus: data['paymentStatus'] ?? false, // Converted to bool
      commissionAmount: data['commissionAmount'] ?? 0,
      mazduri: data['mazduri'] ?? 0,
      totalSale: data['totalSale'] ?? 0,
      sellingProfit: data['sellingProfit'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'merchantName': merchantName,
      'merchantAddress': merchantAddress,
      'merchantContact': merchantContact,
      'productName': productName,
      'productQuantity': productQuantity,
      'productQuantityType': productQuantityType,
      'storeNo': storeNo,
      'roomNo': roomNo,
      'storeRent': storeRent,
      'truckId': truckId,
      'truckQuantity': truckQuantity,
      'truckRent': truckRent,
      'totalWeight': totalWeight,
      'costPerWeight': costPerWeight,
      'commission': commission,
      'productId': productId,
      'datetime': datetime,
      'paymentStatus': paymentStatus, // No conversion needed
      'commissionAmount': commissionAmount,
      'mazduri': mazduri,
      'totalSale': totalSale,
      'sellingProfit': sellingProfit,
    };
  }
}
