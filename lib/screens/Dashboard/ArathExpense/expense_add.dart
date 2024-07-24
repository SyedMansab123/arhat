// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_import, use_build_context_synchronously

import "package:arhat/common/widgets/customized_textfield.dart";
import "package:arhat/controllers/expense_controllers.dart";
import "package:arhat/data/services/firebase_arhat_expense_service.dart";
import "package:arhat/models/arhat_expense_model.dart";
import "package:arhat/screens/Dashboard/ArathExpense/expense_display.dart";
import "package:arhat/utils/utils.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import "package:intl/intl.dart";

class ExpenseAdd extends StatefulWidget {
  const ExpenseAdd({super.key});

  @override
  State<ExpenseAdd> createState() => _ExpenseAddState();
}

class _ExpenseAddState extends State<ExpenseAdd> {
  late final ArhatExpenseController _controller;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _controller = ArhatExpenseController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 59, 20),
      body: SingleChildScrollView(
        child: Stack(alignment: Alignment.center, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 35,
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Arhat Expense",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(
                height: 200,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(195, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),

                // height: height,
                width: width,
                height: height - 338,
                // padding: const EdgeInsets.only(bottom: 10, top: 50),
                // child:
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Container(
              width: width - 50,
              height: height - 450,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      CustomizedTextfield(
                        myController: _controller.expenseName,
                        hintText: "Enter Expense Name",
                        isPassword: false,
                      ),
                      CustomizedTextfield(
                        myController: _controller.expenseAmount,
                        hintText: "Enter Expense Amount",
                        isPassword: false,
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              // Create a CustomModel object from user input
              CustomExpenseModel model = CustomExpenseModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                expenseName: _controller.expenseName.text,
                expenseAmount: double.parse(_controller.expenseAmount.text),
                datetimeString: DateFormat().format(DateTime.now()),
              );
              String? currentUserId = _auth.currentUser!.uid;
              // Save data to Firestore
              await FirebaseExpenseService()
                  .setData('ArhatExpense', model, currentUserId);

              // Clear text fields after saving data
              _controller.expenseName.clear();
              _controller.expenseAmount.clear();

              List<CustomExpenseModel> savedData =
                  await FirebaseExpenseService()
                      .getSavedData('ArhatExpense', currentUserId);

              // Navigate to the next screen and pass the saved data
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExpenseDisplayScreen(savedData)),
              );
            } catch (e) {
              // Handle error
              // print("Error saving data: $e");
              Utils().toastMessage(e.toString());
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Error"),
                    content:
                        const Text("Failed to save data. Please try again."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        tooltip: 'Increment',
        backgroundColor: const Color.fromARGB(255, 3, 59, 20),
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
