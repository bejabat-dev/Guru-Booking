import 'package:flutter/material.dart';

class Styles {
  AppBar customAppBar(BuildContext context, String title) {
    AppBar a = AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          )),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontSize: 15),
      ),
    );
    return a;
  }

  TextStyle formStyle = const TextStyle(fontSize: 14);

  InputDecoration errorDecoration(Icon icon, String label) {
    InputDecoration i = InputDecoration(
        prefixIcon: icon,
        filled: true,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.red, fontSize: 14),
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.red)));
    return i;
  }

  TextStyle appBarText =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  TextStyle whiteText = const TextStyle(color: Colors.white);
  TextStyle inputText = const TextStyle(fontSize: 14);
  InputDecoration inputDecoration(String label, String? prefix) {
    InputDecoration i = InputDecoration(
        labelStyle: const TextStyle(fontSize: 14),
        labelText: label,
        prefixText: prefix,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none));
    return i;
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input; // Handle edge case where input is empty
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }
}
