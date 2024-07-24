// import 'package:arhat/common/widgets/customized_textfield.dart';
// import 'package:arhat/screens/Dashboard/Activity/Customer/customer_add.dart';
// import 'package:flutter/material.dart';

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:arhat/data/services/firebase_arhat_Merchant_service.dart';
import 'package:arhat/models/arhat_customer_model.dart';
import 'package:arhat/models/arhat_merchant_model.dart';
import 'package:arhat/screens/Dashboard/Activity/Customer/customer_add.dart';
import 'package:arhat/screens/Dashboard/Activity/Merchant/merchant_displayscreen.dart';
import 'package:arhat/screens/Dashboard/dashboard.dart';
import 'package:arhat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arhat/common/widgets/customized_textfield.dart';

class CustomerDisplayScreen extends StatefulWidget {
  final List<CustomCutomerModel>? savedDataCustomer;
  final String merchantId;
  final double merchantProductQuantity;
  final String merchantProductName;
  final String merchantProductQuantityType;
  final double merchantCostPerWeight;
  final double merchantTotalweight;
  final double sellingProfit;

  const CustomerDisplayScreen(
    this.savedDataCustomer, {
    super.key,
    required this.merchantId,
    required this.merchantProductQuantity,
    required this.merchantProductName,
    required this.merchantProductQuantityType,
    required this.merchantCostPerWeight,
    required this.merchantTotalweight,
    required this.sellingProfit,
  });

  @override
  _CustomerDisplayScreenState createState() => _CustomerDisplayScreenState();
}

class _CustomerDisplayScreenState extends State<CustomerDisplayScreen> {
  late TextEditingController _searchFilter;
  List<CustomCutomerModel>? _filteredDataCustomer;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _searchFilter = TextEditingController();
    _filteredDataCustomer = widget.savedDataCustomer;
  }

  @override
  void dispose() {
    _searchFilter.dispose();
    super.dispose();
  }

  void _filterList(String searchText) {
    setState(() {
      _filteredDataCustomer = widget.savedDataCustomer!
          .where((customer) => customer.customerName
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void _deleteCustomer(String merchantId, String customerId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection("users")
            .doc(user.uid)
            .collection("ArhatMerchant")
            .doc(merchantId)
            .collection("ArhatCustomer")
            .doc(customerId)
            .delete()
            .then((value) async {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (Context) => const Dashboard()));
          Utils().toastMessage('Delete  successfully');
        });
      }
    } catch (e) {
      Utils().toastMessage('Failed to Delete: $e');
    }
  }

  void _showDeleteDialog(
      String customerName, String merchantId, String customerId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('DELETE CUSTOMER'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Are you sure to delete the $customerName Detail"),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                // _updateDetails(newDisplayName, newEmail);
                _deleteCustomer(merchantId, customerId);
                Navigator.push(context,
                    MaterialPageRoute(builder: (Context) => const Dashboard()));
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showProductDetailsDialog(
      double productQuantity,
      String quantityType,
      double advancePayment,
      double totalAmount,
      double totalWeight,
      String datetimeString,
      String customerName,
      String customerAdress,
      double customerNumber,
      String productName,
      double remainingAmount) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Customer Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 8.0),
                Text(
                  'Customer Name: ${customerName.toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 59, 20),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text('Customer Address: ${customerAdress.toUpperCase()}'),
                const SizedBox(height: 8.0),
                Text(
                    'Customer Contact: +92${customerNumber.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text('Date & Time : ${datetimeString.toUpperCase()}'),
                const SizedBox(height: 8.0),
                Text('Product Name: ${productName.toUpperCase()}'),
                const SizedBox(height: 8.0),
                Text('Quantity Type: ${quantityType.toUpperCase()}'),
                const SizedBox(height: 8.0),
                Text('Product Quantity: ${productQuantity.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text('Total Amount: ${totalAmount.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text('Advance payment: ${advancePayment.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text('Remaining Amount: ${remainingAmount.toStringAsFixed(0)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(String merchantId, String customerId) {
    // Dummy list of user names for the dropdown
    final List<String> cutomerLabel = [
      'customerAdress',
      'productNumber',
      'customerName',
      'quantityType',
      'productName'
    ];
    String? selectedUserName; // Nullable selected user name
    var newData;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Customer Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Select the Option You want to update',
                        // contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedUserName,
                          hint: const Text('Select Option'), // Placeholder text
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedUserName = newValue;
                            });
                          },
                          items: cutomerLabel
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        newData = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter New Data',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    _updateCustomerDetails(
                        selectedUserName!, newData, merchantId, customerId);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update',
                      style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateCustomerDetails(String selectedUserName, var newData,
      String merchantId, String customerId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection("users")
            .doc(user.uid)
            .collection("ArhatMerchant")
            .doc(merchantId)
            .collection("ArhatCustomer")
            .doc(customerId)
            .update({
          selectedUserName: newData,
        }).then((value) {
          Navigator.push(context,
              MaterialPageRoute(builder: (Context) => const Dashboard()));
          Utils().toastMessage('Details updated successfully');
        });
        // setState(() {
        //   _displayName = newDisplayName;
        //   _email = newEmail;
        // });
      }
    } catch (e) {
      Utils().toastMessage('Failed to update details: $e');
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
            onPressed: () async {
              String? currentUserId = _auth.currentUser!.uid;
              List<CustomMerchantModel> merchantData =
                  await FirebaseMerchantService()
                      .getSavedData('ArhatMerchant', currentUserId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (Context) =>
                          MerchantDisplayScreen(merchantData)));
            },
          ),
          toolbarHeight: 75,
          backgroundColor: const Color.fromARGB(255, 3, 59, 20),
          title: const Text(
            "Customer Data",
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
                if (_filteredDataCustomer != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredDataCustomer!.length,
                      itemBuilder: (context, index) {
                        CustomCutomerModel model =
                            _filteredDataCustomer![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      if (value == "Detail") {
                                        _showProductDetailsDialog(
                                            model.productQuantity,
                                            model.quantityType,
                                            model.advancePayment,
                                            model.totalAmount,
                                            model.totalWeight,
                                            model.datetimeString,
                                            model.customerName,
                                            model.customerAdress,
                                            model.customerNumber,
                                            model.productName,
                                            model.remainingAmount);
                                      } else if (value == "Delete") {
                                        _showDeleteDialog(model.customerName,
                                            widget.merchantId, model.id);
                                      } else if (value == "Update") {
                                        _showUpdateDialog(
                                            widget.merchantId, model.id);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        const PopupMenuItem(
                                          value: "Detail",
                                          child: Text("Detail"),
                                        ),
                                        const PopupMenuItem(
                                          value: "Update",
                                          child: Text("Update"),
                                        ),
                                        const PopupMenuItem(
                                          value: "Delete",
                                          child: Text("Delete"),
                                        ),
                                      ];
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                'Customer Name: ${model.customerName.toUpperCase()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 3, 59, 20),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Advance Payment:  ${model.advancePayment.toString()}',
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Total Amount:  ${model.totalAmount.toString()}',
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Remaining Amount:  ${model.remainingAmount.toString()}',
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Product Quantity:  ${model.productQuantity.toStringAsFixed(0)}',
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Quatity Type:  ${model.quantityType.toUpperCase()}',
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Product Name:  ${model.productName.toUpperCase()}',
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
              MaterialPageRoute(
                  builder: (context) => CustomerAdd(
                        merchantId: widget.merchantId,
                        merchantProductQuantity: widget.merchantProductQuantity,
                        merchantProductName: widget.merchantProductName,
                        merchantProductQuantityType:
                            widget.merchantProductQuantityType,
                        merchantCostPerWeight: widget.merchantCostPerWeight,
                        merchantTotalweight: widget.merchantTotalweight,
                        sellingProfit: widget.sellingProfit,
                      )),
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
