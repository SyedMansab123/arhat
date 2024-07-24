// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:arhat/data/services/firebase_arhat_customer_service.dart';
import 'package:arhat/models/arhat_customer_model.dart';
import 'package:arhat/models/arhat_merchant_model.dart';
import 'package:arhat/screens/Dashboard/Activity/Customer/customer_displayscreen.dart';
import 'package:arhat/screens/Dashboard/Activity/Merchant/merchant_add.dart';
import 'package:arhat/screens/Dashboard/dashboard.dart';
import 'package:arhat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arhat/common/widgets/customized_textfield.dart';

class MerchantDisplayScreen extends StatefulWidget {
  final List<CustomMerchantModel>? savedDataMerchant;

  const MerchantDisplayScreen(this.savedDataMerchant, {super.key});

  @override
  _MerchantDisplayScreenState createState() => _MerchantDisplayScreenState();
}

class _MerchantDisplayScreenState extends State<MerchantDisplayScreen> {
  late TextEditingController _searchFilter;
  List<CustomMerchantModel>? _filteredDataMerchant;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  void _deleteMerchant(
    String merchantId,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection("users")
            .doc(user.uid)
            .collection("ArhatMerchant")
            .doc(merchantId)
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

  void _showDeleteDialog(String merchantId, String merchantName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('DELETE MERCHANT'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Are you sure to delete the $merchantName Detail"),
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
                _deleteMerchant(
                  merchantId,
                );
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
    double commision,
    double commisionAmount,
    double costPerWeight,
    double mazduri,
    double totalWeight,
    String dateTime,
    String merchantName,
    String merchantAddress,
    double merchantContact,
    String productName,
    double productQuantity,
    String productQuantityType,
    String roomNumber,
    String storeNumber,
    double storeRent,
    String truckId,
    double truckQuantity,
    double trucckRent,
    double sellingProfit,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Merchant Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 8.0),
                Text(
                  'Merchant Name: ${merchantName.toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 59, 20),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text('Merchant Address: ${merchantAddress.toUpperCase()}'),
                const SizedBox(height: 8.0),
                Text(
                    'Merchant Contact: +92${merchantContact.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text('Date & Time : ${dateTime.toUpperCase()}'),
                const SizedBox(height: 8.0),
                Text('Product Name: ${productName.toUpperCase()}'),
                const SizedBox(height: 8.0),
                Text('Quantity Type: ${productQuantityType.toUpperCase()}'),
                const SizedBox(height: 8.0),
                Text('Product Quantity: ${productQuantity.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text('Cost of 40 Kg: ${costPerWeight.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text('Total Weight: ${totalWeight.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text('Commision in %: ${commision.toStringAsFixed(0)} %'),
                const SizedBox(height: 8.0),
                Text('Commision Amount: ${commisionAmount.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text(
                    'Profit Selling in %: ${sellingProfit.toStringAsFixed(0)} %'),
                const SizedBox(height: 8.0),
                Text('Mazduri Amount: ${mazduri.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text('Room No: ${roomNumber.toString()}'),
                const SizedBox(height: 8.0),
                Text('Store No: ${storeNumber.toString()}'),
                const SizedBox(height: 8.0),
                Text('Store Rent: ${storeRent.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text('Truck Id: ${truckId.toString()}'),
                const SizedBox(height: 8.0),
                Text('Truck Quantity: ${truckQuantity.toString()}'),
                const SizedBox(height: 8.0),
                Text('Truck Rent: ${trucckRent.toString()}'),
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

  void _showUpdateDialog(
    String merchantId,
  ) {
    // Dummy list of user names for the dropdown
    final List<String> cutomerLabel = [
      'merchantName',
      'merchantAddress',
      'merchantContact',
      'productName',
      'commissionAmount',
      'sellingProfit'
    ];
    String? selectedUserName; // Nullable selected user name
    var newData;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Merchant Details'),
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
                      selectedUserName!,
                      newData,
                      merchantId,
                    );
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

  void _updateCustomerDetails(
    String selectedUserName,
    var newData,
    String merchantId,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection("users")
            .doc(user.uid)
            .collection("ArhatMerchant")
            .doc(merchantId)
            .update({
          selectedUserName: newData,
        }).then((value) {
          Utils().toastMessage('Details updated successfully');
          Navigator.push(context,
              MaterialPageRoute(builder: (Context) => const Dashboard()));
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
            "Merchant Data",
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
                if (_filteredDataMerchant != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredDataMerchant!.length,
                      itemBuilder: (context, index) {
                        CustomMerchantModel model =
                            _filteredDataMerchant![index];
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
                                            model.commission!,
                                            model.commissionAmount!,
                                            model.costPerWeight!,
                                            model.mazduri!,
                                            model.totalWeight!,
                                            model.datetime!,
                                            model.merchantName!,
                                            model.merchantAddress!,
                                            model.merchantContact!,
                                            model.productName!,
                                            model.productQuantity!,
                                            model.productQuantityType!,
                                            model.roomNo!,
                                            model.storeNo!,
                                            model.storeRent!,
                                            model.truckId!,
                                            model.truckQuantity!,
                                            model.truckRent!,
                                            model.sellingProfit!);
                                      } else if (value == "Delete") {
                                        _showDeleteDialog(model.productId!,
                                            model.merchantName!);
                                      } else if (value == "Update") {
                                        _showUpdateDialog(model.productId!);
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
                                'Merchant Name: ${model.merchantName!.toUpperCase()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 3, 59, 20),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Product Name:  ${model.productName!.toUpperCase()}',
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Product Quantity:  ${model.productQuantity!.toStringAsFixed(0)}',
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Quantity Type:  ${model.productQuantityType!.toUpperCase()}',
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Total Product Weight:  ${model.totalWeight!.toString()}',
                              ),
                              const SizedBox(height: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255,
                                          3,
                                          59,
                                          20), // Change this to the desired color
                                    ),
                                    onPressed: () async {
                                      String? currentUserId =
                                          _auth.currentUser!.uid;
                                      String merchantId =
                                          model.productId!.toString();
                                      double productQuantity =
                                          model.productQuantity!;
                                      String merchantProductName =
                                          model.productName!.toString();
                                      String merchantProductQuantityType =
                                          model.productQuantityType!.toString();
                                      double merchantCostPerWeight =
                                          (model.costPerWeight! / 40);
                                      double merchantTotalweight =
                                          model.totalWeight!;
                                      double sellingProfit =
                                          model.sellingProfit!;
                                      List<CustomCutomerModel>
                                          savedDataCustomer =
                                          await FirebaseCustomerService()
                                              .getSavedData('ArhatCustomer',
                                                  currentUserId, merchantId);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerDisplayScreen(
                                                    merchantId: merchantId,
                                                    merchantProductQuantity:
                                                        productQuantity,
                                                    merchantProductName:
                                                        merchantProductName,
                                                    merchantProductQuantityType:
                                                        merchantProductQuantityType,
                                                    merchantCostPerWeight:
                                                        merchantCostPerWeight,
                                                    merchantTotalweight:
                                                        merchantTotalweight,
                                                    sellingProfit:
                                                        sellingProfit,
                                                    savedDataCustomer)),
                                      );
                                    },
                                    child: const Text(
                                      'Add Customer',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
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
              MaterialPageRoute(builder: (context) => const MerchantAdd()),
            );
          },
          tooltip: 'Add',
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
