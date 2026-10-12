import 'package:flutter/material.dart';

InputDecoration customInputDecoration(
    String hintText,
    Widget prefixIcon,
    {String? labelText,
    Widget? suffixIcon
    }

  ) {
    return InputDecoration(
                labelText: labelText,
                hintText: hintText,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.indigo),
                ),
              );
  }