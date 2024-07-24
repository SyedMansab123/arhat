import 'package:flutter/material.dart';

class CustomizedButton extends StatelessWidget {
  final String? buttonTexts;
  final Color? buttonColor;
  final Color? textColor;
  final bool loading;
  final VoidCallback? onPressed;
  const CustomizedButton(
      {super.key,
      this.buttonTexts,
      this.buttonColor,
      this.onPressed,
      this.textColor,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: buttonColor,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: loading
                    ? CircularProgressIndicator(
                        strokeWidth: 3,
                        color: textColor,
                      )
                    : Text(
                        buttonTexts!,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                        ),
                      )),
          ),
        ));
  }
}
