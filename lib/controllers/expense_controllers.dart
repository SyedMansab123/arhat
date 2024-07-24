import 'package:flutter/material.dart';

class ArhatExpenseController {
  final TextEditingController expenseName = TextEditingController();
  final TextEditingController expenseAmount = TextEditingController();
  void dispose() {
    expenseName.dispose();
    expenseAmount.dispose();
  }
}
