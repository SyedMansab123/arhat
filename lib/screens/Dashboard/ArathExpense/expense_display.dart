// ignore_for_file: library_private_types_in_public_api

import 'package:arhat/screens/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:arhat/common/widgets/customized_textfield.dart';
import 'package:arhat/models/arhat_expense_model.dart';
import 'package:arhat/screens/Dashboard/ArathExpense/expense_add.dart';

class ExpenseDisplayScreen extends StatefulWidget {
  final List<CustomExpenseModel>? savedData;

  const ExpenseDisplayScreen(this.savedData, {super.key});

  @override
  _ExpenseDisplayScreenState createState() => _ExpenseDisplayScreenState();
}

class _ExpenseDisplayScreenState extends State<ExpenseDisplayScreen> {
  late TextEditingController _searchFilter;
  List<CustomExpenseModel>? _filteredData;

  @override
  void initState() {
    super.initState();
    _searchFilter = TextEditingController();
    _filteredData = widget.savedData;
  }

  @override
  void dispose() {
    _searchFilter.dispose();
    super.dispose();
  }

  void _filterList(String searchText) {
    setState(() {
      _filteredData = widget.savedData!
          .where((expense) => expense.expenseName
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ),
              );
            },
          ),
          //const BackButton(color: Colors.white),
          toolbarHeight: 75,
          backgroundColor: const Color.fromARGB(255, 3, 59, 20),
          title: const Text(
            "Expense Data",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                CustomizedTextfield(
                  myController: _searchFilter,
                  hintText: "Search",
                  isPassword: false,
                  iconData: Icons.search,
                  onChanged: _filterList,
                ),
                if (_filteredData != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredData!.length,
                      itemBuilder: (context, index) {
                        CustomExpenseModel model = _filteredData![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expense Name: ${model.expenseName.toUpperCase()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 3, 59, 20),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Expense Amount:  ${model.expenseAmount.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExpenseAdd()),
            );
          },
          tooltip: 'Increment',
          backgroundColor: const Color.fromARGB(255, 3, 59, 20),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
