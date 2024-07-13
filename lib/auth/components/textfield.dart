import 'package:flutter/material.dart';

/// Widget untuk membuat text field yang dapat dikustomisasi.
class MyTextField extends StatelessWidget {
  /// Controller untuk mengelola teks dalam text field.
  final controller;

  /// Teks yang ditampilkan ketika text field kosong.
  final String hintText;

  /// Boolean untuk menentukan apakah teks harus disembunyikan.
  final bool obscureText;

  /// Konstruktor untuk [MyTextField] dengan parameter yang diperlukan.
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
