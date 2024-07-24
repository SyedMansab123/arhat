// ignore_for_file: file_names, use_key_in_widget_constructors, avoid_print

import 'package:arhat/screens/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:arhat/data/services/firebase_arhat_Merchant_service.dart';
import 'package:arhat/data/services/firebase_arhat_expense_service.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // Variables to store the sums
  double totalExpenseAmount = 0.0;
  double totalCommissionAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // Call the method to fetch data and calculate sums
    fetchDataAndCalculateSums();
  }

  // Method to fetch data and calculate sums
  Future<void> fetchDataAndCalculateSums() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      print('Error: No current user found.');
      return;
    }

    final savedData =
        await FirebaseExpenseService().getSavedData('ArhatExpense', userId);
    final merchantData =
        await FirebaseMerchantService().getSavedData('ArhatMerchant', userId);

    // Calculate total expense
    totalExpenseAmount =
        savedData.fold(0.0, (sum, expense) => sum + expense.expenseAmount);

    // Calculate total commission
    totalCommissionAmount = merchantData.fold(
        0.0, (sum, merchant) => sum + merchant.commissionAmount!);

    // Update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        toolbarHeight: 75,
        backgroundColor: const Color.fromARGB(255, 3, 59, 20),
        title: const Text(
          "Profit & Loss",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 120),
              Text(
                'Total Expense: ${totalExpenseAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                'Total Commission: ${totalCommissionAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    child: SfCircularChart(
                      series: <CircularSeries>[
                        // Render pie chart
                        PieSeries<ChartData, String>(
                          dataSource: <ChartData>[
                            ChartData(
                                'Expenses',
                                totalExpenseAmount,
                                const Color.fromARGB(
                                    255, 201, 89, 81)), // Change color here
                            ChartData(
                                'Commissions',
                                totalCommissionAmount,
                                const Color.fromARGB(
                                    255, 45, 148, 76)), // Change color here
                          ],
                          pointColorMapper: (ChartData data, _) => data.color!,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            textStyle:
                                TextStyle(fontSize: 12, color: Colors.black),
                            connectorLineSettings: ConnectorLineSettings(
                              length: '20%',
                              color: Colors.blue,
                            ),
                            // Show percentage values in data labels
                            showCumulativeValues: true,
                          ),
                          // Format the label text to display the amount
                          dataLabelMapper: (ChartData data, _) =>
                              data.y.toStringAsFixed(1),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: totalExpenseAmount > totalCommissionAmount
                        ? Text(
                            'Loss: ${(totalExpenseAmount - totalCommissionAmount).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 187, 28, 28)),
                          )
                        : Text(
                            'Profit: ${(totalCommissionAmount - totalExpenseAmount).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 39, 116, 41)),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
