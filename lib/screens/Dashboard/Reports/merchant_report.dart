// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:arhat/screens/Dashboard/Reports/view_reports.dart';
import 'package:flutter/material.dart';
import 'package:arhat/models/arhat_merchant_model.dart';
import 'package:arhat/common/widgets/customized_textfield.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MerchantReportScreen extends StatefulWidget {
  final List<CustomMerchantModel>? savedDataMerchant;

  const MerchantReportScreen(this.savedDataMerchant, {super.key});

  @override
  _MerchantReportScreenState createState() => _MerchantReportScreenState();
}

class _MerchantReportScreenState extends State<MerchantReportScreen> {
  late TextEditingController _searchFilter;
  List<CustomMerchantModel>? _filteredDataMerchant;

  @override
  void initState() {
    super.initState();
    _searchFilter = TextEditingController();
    _filteredDataMerchant = widget.savedDataMerchant;
  }

  @override
  void dispose() {
    _searchFilter.dispose();
    super.dispose();
  }

  void _filterList(String searchText) {
    setState(() {
      _filteredDataMerchant = widget.savedDataMerchant!
          .where((merchant) => merchant.merchantName!
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
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
        _filteredDataMerchant = widget.savedDataMerchant!.where((merchant) {
          DateTime merchantDate = DateFormat().parse(merchant.datetime!);
          return merchantDate.year == pickedDate.year &&
              merchantDate.month == pickedDate.month;
        }).toList();
      });
    }
  }

  Future<void> _generateAndPrintPDF(CustomMerchantModel merchant, double khaam,
      double totalKahrcha, double totalBill) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    " ${DateFormat().format(DateTime.now())}",
                    textAlign: pw.TextAlign.right,
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Merchant Invoice', style: pw.TextStyle(fontSize: 24)),
              // pw.Divider(),
              pw.SizedBox(height: 40),
              pw.Text('Merchant Detail', style: pw.TextStyle(fontSize: 18)),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Merchant Name : ${merchant.merchantName}'),
                          pw.Text('Address : ${merchant.merchantAddress}'),
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              "Contact No : +92${merchant.merchantContact!.toStringAsFixed(0)}"),
                          pw.Text('')
                        ]),
                    pw.SizedBox(
                      width: 50,
                    ),
                  ]),
              pw.SizedBox(height: 40),
              pw.Text('Expense Details', style: pw.TextStyle(fontSize: 18)),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Store No : ${merchant.storeNo}'),
                        pw.Text("Truck ID : ${merchant.truckId}"),
                        pw.Text(
                            "Labour Cost : ${merchant.mazduri!.toStringAsFixed(0)}"),
                      ],
                    ),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              "Store Rent : ${merchant.storeRent!.toStringAsFixed(0)}"),
                          pw.Text(
                              "Truck Rent : ${merchant.truckRent!.toStringAsFixed(0)}"),
                          pw.Text(
                              "Commission : ${merchant.commissionAmount!.toStringAsFixed(0)}"),
                        ]),
                    pw.SizedBox(
                      width: 50,
                    ),
                  ]),
              pw.SizedBox(height: 40),
              pw.Text('Total', style: pw.TextStyle(fontSize: 18)),
              pw.Divider(),

              pw.SizedBox(height: 10),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Khaam: ${khaam.toStringAsFixed(0)}'),
                    pw.Text(
                        "Total Expense: ${totalKahrcha.toStringAsFixed(0)}"),
                    pw.SizedBox(width: 50),
                  ]),
              pw.Divider(),
              pw.Text('Bill Amount: ${totalBill.toStringAsFixed(0)}'),
              // Add more details as needed
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewsReports(),
                ),
              );
            },
          ),
          toolbarHeight: 75,
          backgroundColor: const Color.fromARGB(255, 3, 59, 20),
          title: const Text(
            "Merchant Data",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                CustomizedTextfield(
                  myController: _searchFilter,
                  hintText: "Search",
                  isPassword: false,
                  iconData: Icons.search,
                  onChanged: _filterList,
                ),
                if (_filteredDataMerchant != null)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateColor.resolveWith(
                            (states) => const Color.fromARGB(255, 3, 59, 20)),
                        headingTextStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        columns: const [
                          DataColumn(label: Text('Sr No')),
                          DataColumn(label: Text('Date & Time')),
                          DataColumn(label: Text('Merchant Name')),
                          DataColumn(label: Text('Address')),
                          DataColumn(label: Text('Contact No')),
                          DataColumn(label: Text('Product Name')),
                          DataColumn(label: Text('Product Quantity')),
                          DataColumn(label: Text('Quantity Type')),
                          DataColumn(label: Text('Total Product Weight')),
                          DataColumn(label: Text('Cost Of 40 kg Weight')),
                          DataColumn(label: Text('Store No')),
                          DataColumn(label: Text('Room No')),
                          DataColumn(label: Text('Store Rent Amount')),
                          DataColumn(label: Text('Mazduri')),
                          DataColumn(label: Text('Commision in %')),
                          DataColumn(label: Text('Commision Amount')),
                          DataColumn(label: Text('Truck ID')),
                          DataColumn(label: Text('Truck Quantity')),
                          DataColumn(label: Text('Truck Rent Amount')),
                          DataColumn(
                              label: Text('Total Product Amount (KHAAM)')),
                          DataColumn(label: Text('Total Kharcha ')),
                          DataColumn(label: Text('Bill Amount')),
                          DataColumn(label: Text('Payment Status ')),
                          DataColumn(
                              label: Text('Print Invoice')), // New column
                        ],
                        rows:
                            _filteredDataMerchant!.asMap().entries.map((entry) {
                          int index = entry.key;
                          CustomMerchantModel merchant = entry.value;
                          final totalCost = (merchant.costPerWeight! / 40);
                          final khaam =
                              ((totalCost * merchant.sellingProfit! / 100) +
                                      totalCost) *
                                  double.parse(
                                      merchant.totalWeight!.toStringAsFixed(0));
                          final totalKharcha = (merchant.storeRent! +
                              merchant.truckRent! +
                              merchant.commissionAmount!);
                          final billAmount = khaam - totalKharcha;

                          return DataRow(cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(Text(merchant.datetime!.toString())),
                            DataCell(
                                Text(merchant.merchantName!.toUpperCase())),
                            DataCell(
                                Text(merchant.merchantAddress!.toUpperCase())),
                            DataCell(Text(
                                merchant.merchantContact!.toStringAsFixed(0))),
                            DataCell(Text(merchant.productName!.toUpperCase())),
                            DataCell(Text(
                                merchant.productQuantity!.toStringAsFixed(0))),
                            DataCell(Text(
                                merchant.productQuantityType!.toUpperCase())),
                            DataCell(
                                Text(merchant.totalWeight!.toStringAsFixed(0))),
                            DataCell(Text(
                                merchant.costPerWeight!.toStringAsFixed(0))),
                            DataCell(Text(merchant.storeNo!.toUpperCase())),
                            DataCell(Text(merchant.roomNo!.toUpperCase())),
                            DataCell(Text(merchant.storeRent!.toString())),
                            DataCell(Text(merchant.mazduri!.toString())),
                            DataCell(Text(
                                "${merchant.commission!.toStringAsFixed(0)} %")),
                            DataCell(Text(
                                merchant.commissionAmount!.toStringAsFixed(0))),
                            DataCell(Text(merchant.truckId!.toUpperCase())),
                            DataCell(Text(
                                merchant.truckQuantity!.toStringAsFixed(0))),
                            DataCell(
                                Text(merchant.truckRent!.toStringAsFixed(0))),
                            DataCell(Text(khaam.toString())),
                            DataCell(Text(totalKharcha.toStringAsFixed(0))),
                            DataCell(Text(billAmount.toStringAsFixed(0))),
                            DataCell(merchant.paymentStatus!
                                ? const Text("Paid",
                                    style: TextStyle(color: Colors.green))
                                : const Text("Unpaid",
                                    style: TextStyle(color: Colors.red))),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.print),
                                    onPressed: () => _generateAndPrintPDF(
                                        merchant,
                                        khaam,
                                        totalKharcha,
                                        billAmount),
                                  ),
                                  // IconButton(
                                  //   icon: const Icon(Icons.download),
                                  //   onPressed: () =>
                                  //       _generateAndPrintPDF(merchant),
                                  // ),
                                ],
                              ),
                            ), // Action buttons
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
