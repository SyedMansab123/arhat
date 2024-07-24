class CustomExpenseModel {
  final String id;
  final String expenseName;
  final double expenseAmount;
  final String datetimeString; // New field for datetime string

  CustomExpenseModel({
    required this.id,
    required this.expenseName,
    required this.expenseAmount,
    required this.datetimeString,
  });

  factory CustomExpenseModel.fromMap(String id, Map<String, dynamic> data) {
    return CustomExpenseModel(
      id: id,
      expenseName: data['expenseName'] ?? '',
      expenseAmount: data['expenseAmount'] ?? 0.0,
      datetimeString: data['datetimeString'] ?? '', // Assigning value from map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'expenseName': expenseName,
      'expenseAmount': expenseAmount,
      'datetimeString': datetimeString, // Adding datetime string to the map
    };
  }
}
