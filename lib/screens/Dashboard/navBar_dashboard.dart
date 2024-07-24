// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:arhat/data/services/firebase_arhat_Merchant_service.dart';
import 'package:arhat/models/arhat_merchant_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion charts package

class NavBarDashboard extends StatefulWidget {
  const NavBarDashboard({Key? key});

  @override
  State<NavBarDashboard> createState() => _NavBarDashboardState();
}

class _NavBarDashboardState extends State<NavBarDashboard> {
  bool loading = false;
  late List<CustomMerchantModel> merchantData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Assuming FirebaseAuth.instance.currentUser is already initialized
    String userId = FirebaseAuth.instance.currentUser!.uid;
    merchantData =
        await FirebaseMerchantService().getSavedData('ArhatMerchant', userId);
    setState(() {}); // Update the state after fetching data
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 226, 220),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 75,
        backgroundColor: const Color.fromARGB(255, 3, 59, 20),
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
                child: Container(
                  width: width - 75,
                  height: height - 600,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 156, 235, 158),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CarouselSlider(
                    items: [
                      Image.asset('assets/profit.jpg', fit: BoxFit.fill),
                      Image.asset('assets/expenseManage.jpg', fit: BoxFit.fill),
                      Image.asset('assets/expenseManage.jpg', fit: BoxFit.fill),
                    ],
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayInterval: const Duration(seconds: 3),
                      enableInfiniteScroll: true,
                      viewportFraction: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      20), // Add some space between CarouselSlider and line chart
              if (merchantData.isNotEmpty)
                SizedBox(
                  width: width - 75,
                  height: 300, // Set height for the chart container
                  child: SfCartesianChart(
                    series: <CartesianSeries>[
                      LineSeries<ChartData, DateTime>(
                        dataSource: merchantData
                            .map((data) => ChartData(
                                DateFormat().parse(data.datetime!),
                                data.totalSale!))
                            .toList(),
                        dashArray: const <double>[5, 5],
                        xValueMapper: (ChartData data, _) => data.dateTime,
                        yValueMapper: (ChartData data, _) => data.totalSale,
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final DateTime dateTime;
  final double totalSale;

  ChartData(this.dateTime, this.totalSale);
}
