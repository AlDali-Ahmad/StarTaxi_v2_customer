import 'package:flutter/material.dart';

import 'package:intl_phone_field/intl_phone_field.dart';

class CustomPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onCountryChanged;
  final String initialCountryCode;
  final String languageCode;

  const CustomPhoneField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onCountryChanged,
    this.initialCountryCode = 'SY',
    this.languageCode = 'ar',
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  late String completeNumber;

  @override
  void initState() {
    super.initState();
    completeNumber = '';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: IntlPhoneField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 17.0),
          hintTextDirection: TextDirection.rtl,
        ),
        initialCountryCode: widget.initialCountryCode,
        languageCode: widget.languageCode,
        textAlign: TextAlign.start,
        onChanged: (phone) {
          setState(() {
            completeNumber = phone.completeNumber;
          });
          widget.controller.text = completeNumber;
          widget.onChanged?.call(completeNumber);
        },
        onCountryChanged: (country) {
          widget.onCountryChanged?.call(country.name);
        },
      ),
    );
  }
}
