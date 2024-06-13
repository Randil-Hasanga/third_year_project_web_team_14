import 'package:flutter/material.dart';

class TextFieldWidgets {
  TextFieldWidgets();

  Widget outlinedNormalTextFieldwithValidate(Function(String?) onSaved,
      String hintText, TextEditingController controller,
      {required bool validate}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
          onSaved: onSaved,
          validator: validate ? (value) => validateField(value) : null,
        ),
      ),
    );
  }

  Widget outlinedEmailTextFieldwithValidate(Function(String?) onSaved,
      String hintText, TextEditingController controller,
      {required bool validate}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
          onSaved: onSaved,
          validator: validate ? (value) => validateEmail(value) : null,
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter Email";
    }
    if (!isValidEmail(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  bool isValidEmail(String value) {
    return value.contains(
      RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
    );
  }

  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill the field";
    } else {
      return null;
    }
  }

  String? validateContact(String? _value) {
    if (_value == null || _value.isEmpty) {
      return 'Please enter contact no';
    }
    final regex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!regex.hasMatch(_value)) {
      return "Invalid contact number";
    }
    return null;
  }

  Widget outlinedContactTextFieldwithValidate(Function(String?) onSaved,
      String hintText, TextEditingController controller,
      {required bool validate}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
          onSaved: onSaved,
          validator: validate ? (value) => validateContact(value) : null,
        ),
      ),
    );
  }

  Widget outlinedNormalTextField(
    Function(String?) onSaved,
    String hintText,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
          onSaved: onSaved,
        ),
      ),
    );
  }
}
