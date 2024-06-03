import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final Icon prefixicon;
  final bool obscure;
  final TextEditingController controller;
  final int? maxlines;
  final int? maxkength;
  final Function(String)? onChanged;

  const CustomTextForm({
    super.key, 
    required this.hinttext, 
    required this.prefixicon, 
    required this.obscure, 
    required this.controller, 
    this.maxlines, // Optional maxlines
    this.maxkength, // Optional maxkength
    this.onChanged, // Optional onChanged function
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxlines ?? 1, // Default to 1 if null
      maxLength: maxkength,
      onChanged: onChanged, // Add the onChanged callback here
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIconColor: Colors.white, 
        labelStyle: TextStyle(color: Colors.white),
        hintText: hinttext, 
        prefixIcon: prefixicon, 
        hintStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ), 
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ), 
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ), 
      ),
    );
  }
}
