// // ignore_for_file: library_private_types_in_public_api, prefer_const_literals_to_create_immutables

// import 'package:arhat/data/services/firebase_arhat_customer_service.dart';
// import 'package:arhat/models/arhat_customer_model.dart';
// import 'package:arhat/models/arhat_merchant_model.dart';
// import 'package:arhat/screens/Dashboard/Reports/view_reports.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// ignore_for_file: library_private_types_in_public_api, prefer_const_literals_to_create_immutables

import 'package:arhat/common/widgets/customized_textfield.dart';
import 'package:arhat/data/services/firebase_arhat_customer_service.dart';
import 'package:arhat/models/arhat_customer_model.dart';
import 'package:arhat/models/arhat_merchant_model.dart';
import 'package:arhat/screens/Dashboard/Reports/view_reports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerViewReport extends StatefulWidget {
  final List<CustomMerchantModel>? savedDataMerchant;

  const CustomerViewReport(this.savedDataMerchant, {super.key});

  @override
  _CustomerViewReportState createState() => _CustomerViewReportState();
}

class _CustomerViewReportState extends State<CustomerViewReport> {
  late List<CustomCutomerModel>? _filteredDataCustomer = [];
  late List<CustomCutomerModel>? _allCustomerData = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
    _filteredDataCustomer;
  }

  Future<void> _fetchCustomerData() async {
    if (widget.savedDataMerchant != null) {
      List<CustomCutomerModel> customers = [];
      String? currentUserId = _auth.currentUser!.uid;

      for (CustomMerchantModel merchant in widget.savedDataMerchant!) {
        String merchantId = merchant.productId.toString();
        List<CustomCutomerModel> merchantCustomers =
            await FirebaseCustomerService()
                .getSavedData('ArhatCustomer', currentUserId, merchantId);
        customers.addAll(merchantCustomers);
      }

      setState(() {
        _allCustomerData = customers;
        _filterCustomerData();
      });
    }
  }

  void _filterCustomerData() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredDataCustomer = _allCustomerData;
      } else {
        _filteredDataCustomer = _allCustomerData!
            .where((customer) => customer.customerName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
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
        _filteredDataCustomer = _allCustomerData!.where((customer) {
          // Parse the datetimeString into a DateTime object
          DateTime customerDate = DateFormat().parse(customer.datetimeString);
          // Compare the year and month
          return customerDate.year == pickedDate.year &&
              customerDate.month == pickedDate.month;
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
            "Customer Data",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            CustomizedTextfield(
              myController: _searchController,
              hintText: "Search",
              isPassword: false,
              iconData: Icons.search,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _filterCustomerData();
                });
              },
            ),
            Expanded(
              child: _filteredDataCustomer != null
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateColor.resolveWith(
                                (states) =>
                                    const Color.fromARGB(255, 3, 59, 20)),
                            headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            columns: [
                              const DataColumn(
                                  label:
                                      Text('Sr No')), // Added row number column
                              const DataColumn(label: Text('Date & time')),
                              const DataColumn(label: Text('Customer Name')),
                              const DataColumn(label: Text('Address')),
                              const DataColumn(label: Text('Contact No')),
                              const DataColumn(label: Text('Product Name')),
                              const DataColumn(label: Text('Product Quantity')),
                              const DataColumn(label: Text('Quantity Type')),
                              const DataColumn(label: Text('Remaining Amount')),
                              const DataColumn(label: Text('Total Amount')),
                            ],
                            rows: _filteredDataCustomer!
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key; // Get the current index
                              CustomCutomerModel customer =
                                  entry.value; // Access the customer data
                              return DataRow(cells: [
                                DataCell(Text((index + 1)
                                    .toString())), // Add row number (index + 1 for 1-based indexing)
                                DataCell(
                                    Text(customer.datetimeString.toString())),
                                DataCell(
                                    Text(customer.customerName.toUpperCase())),
                                DataCell(Text(
                                    customer.customerAdress.toUpperCase())),
                                DataCell(Text(
                                    "+92${customer.customerNumber.toStringAsFixed(0)}")),
                                DataCell(
                                    Text(customer.productName.toUpperCase())),
                                DataCell(Text(customer.productQuantity
                                    .toStringAsFixed(0))),
                                DataCell(
                                    Text(customer.quantityType.toUpperCase())),
                                DataCell(Text(customer.remainingAmount
                                    .toStringAsFixed(0))),
                                DataCell(Text(
                                    customer.totalAmount.toStringAsFixed(0))),
                              ]);
                            }).toList(),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
