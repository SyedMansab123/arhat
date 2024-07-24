//  import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomizedTextfield extends StatefulWidget {
  final TextEditingController myController;
  final String? hintText;
  final String? helperText;
  final String? text;
  final bool? isPassword;
  final IconData? iconData;
  final bool readonly;
  final String prefix;
  final ValueChanged<String>? onChanged; // New parameter for onChange function

  const CustomizedTextfield({
    super.key,
    required this.myController,
    this.hintText,
    this.helperText,
    this.text,
    this.isPassword,
    this.iconData,
    this.onChanged,
    this.readonly = false,
    this.prefix = "", // Initialize the onChanged parameter
  });

  @override
  State<CustomizedTextfield> createState() => _CustomizedTextfieldState();
}

class _CustomizedTextfieldState extends State<CustomizedTextfield> {
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        readOnly: widget.readonly,
        keyboardType: widget.isPassword!
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        enableSuggestions: !widget.isPassword!,
        autocorrect: !widget.isPassword!,
        obscureText: widget.isPassword! ? passwordVisible : false,
        controller: widget.myController,
        onChanged: widget.onChanged,
        // Pass the onChanged function
        decoration: InputDecoration(
          suffixIcon: widget.isPassword!
              ? IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(widget.iconData),
                  onPressed: () {},
                ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: const Color(0xffE8ECF4),
          filled: true,
          hintText: widget.hintText,
          prefixText: widget.prefix,
          helperText: widget.helperText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return widget.text ??
                'Field cannot be empty'; // Use provided text or default message
          }
          return null;
        },
      ),
    );
  }
}
