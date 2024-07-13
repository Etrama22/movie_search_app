import 'package:flutter/material.dart';

/// Widget tombol kustom untuk autentikasi.
class MyButton extends StatelessWidget {
  /// Fungsi yang dipanggil ketika tombol ditekan.
  final Function()? onTap;

  /// Konstruktor untuk [MyButton], memerlukan fungsi [onTap].
  const MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black, // Warna latar tombol.
          borderRadius: BorderRadius.circular(8), // Radius sudut tombol.
        ),
        child: const Center(
          child: Text(
            "Sign In", // Teks yang ditampilkan pada tombol.
            style: TextStyle(
              color: Colors.white, // Warna teks.
              fontWeight: FontWeight.bold, // Ketebalan teks.
              fontSize: 16, // Ukuran font teks.
            ),
          ),
        ),
      ),
    );
  }
}
