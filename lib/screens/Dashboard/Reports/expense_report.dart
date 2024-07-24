// // ignore_for_file: library_private_types_in_public_api, unnecessary_const, prefer_const_literals_to_create_immutables, unnecessary_to_list_in_spreads

// import 'package:arhat/screens/Dashboard/Reports/view_reports.dart';
// import 'package:flutter/material.dart';
// import 'package:arhat/common/widgets/customized_textfield.dart';
// import 'package:arhat/models/arhat_expense_model.dart';

// ignore_for_file: library_private_types_in_public_api, unnecessary_const, prefer_const_literals_to_create_immutables, unnecessary_to_list_in_spreads, use_super_parameters

import 'package:arhat/screens/Dashboard/Reports/view_reports.dart';
import 'package:flutter/material.dart';
import 'package:arhat/common/widgets/customized_textfield.dart';
import 'package:arhat/models/arhat_expense_model.dart';
import 'package:intl/intl.dart'; // for parsing dates

class ExpenseReportScreen extends StatefulWidget {
  final List<CustomExpenseModel>? savedData;

  const ExpenseReportScreen(this.savedData, {Key? key}) : super(key: key);

  @override
  _ExpenseReportScreenState createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
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

  double getTotalExpenseAmount() {
    if (_filteredData != null) {
      return _filteredData!
          .fold(0, (sum, expense) => sum + expense.expenseAmount);
    }
    return 0;
  }

  Future<void> _filterByMonthAndYear(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        _filteredData = widget.savedData!.where((expense) {
          // Parse the datetimeString into a DateTime object
          DateTime expenseDate = DateFormat().parse(expense.datetimeString);
          // Compare the year and month
          return expenseDate.year == pickedDate.year &&
              expenseDate.month == pickedDate.month;
        }).toList();
      });
    }
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
                  builder: (context) => const ViewsReports(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () => _filterByMonthAndYear(context),
            ),
          ],
          toolbarHeight: 75,
          backgroundColor: const Color.fromARGB(255, 3, 59, 20),
          title: const Text(
            "Expense Data",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 3, 59, 20)),
                    headingTextStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    columns: const [
                      DataColumn(
                        label: Text('Sr no',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Date & Time',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Expense Name',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Expense Amount',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: [
                      ..._filteredData!.asMap().entries.map((entry) {
                        int index = entry.key;
                        CustomExpenseModel model = entry.value;
                        return DataRow(cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(model.datetimeString.toString())),
                          DataCell(Text(model.expenseName,
                              style: const TextStyle(fontSize: 16.0))),
                          DataCell(Text(
                            model.expenseAmount.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 16.0),
                          )),
                        ]);
                      }).toList(),
                      DataRow(cells: [
                        const DataCell(Text("")),
                        const DataCell(Text("")),
                        const DataCell(Text('Total',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(
                          getTotalExpenseAmount().toStringAsFixed(2),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        )),
                      ]),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
