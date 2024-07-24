class CustomCutomerModel {
  final String id;
  final String customerAdress;
  final String productName;
  final String quantityType;
  final String customerName;
  final double customerNumber;
  final double productQuantity;
  final String datetimeString;
  final double advancePayment;
  final double totalWeight;
  final double totalAmount; // New field for datetime string
  final double remainingAmount;
  final double merchantCustomerId;

  CustomCutomerModel({
    required this.id,
    required this.customerAdress,
    required this.customerNumber,
    required this.customerName,
    required this.productName,
    required this.productQuantity,
    required this.quantityType,
    required this.datetimeString,
    required this.advancePayment,
    required this.totalWeight,
    required this.totalAmount,
    required this.remainingAmount,
    required this.merchantCustomerId,
  });

  factory CustomCutomerModel.fromMap(String id, Map<String, dynamic> data) {
    return CustomCutomerModel(
      id: id,
      customerAdress: data['customerAdress'] ?? '',
      customerName: data['customerName'] ?? '',
      productName: data['productName'] ?? '',
      quantityType: data['quantityType'] ?? '',
      customerNumber: data['productNumber'] ?? 0.0,
      productQuantity: data['productQuantity'] ?? 0.0,
      datetimeString: data['datetimeString'] ?? '',
      advancePayment: data['advancePayment'] ?? 0.0,
      totalWeight: data['totalWeight'] ?? 0.0, // Assigning value from map
      totalAmount: data['totalAmount'] ?? 0.0,
      remainingAmount: data['remainingAmount'] ?? 0.0,
      merchantCustomerId: data['merchantCustomerId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerAdress': customerAdress,
      'productNumber': customerNumber,
      'customerName': customerName,
      'productQuantity': productQuantity,
      'quantityType': quantityType,
      'productName': productName,
      'datetimeString': datetimeString,
      'totalWeight': totalWeight,
      'advancePayment': advancePayment, // Adding datetime string to the map
      'totalAmount': totalAmount,
      'remainingAmount': remainingAmount,
      'merchantCustomerId': merchantCustomerId,
    };
  }
}
