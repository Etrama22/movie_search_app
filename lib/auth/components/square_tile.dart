import 'package:flutter/material.dart';

/// Widget untuk menampilkan sebuah tile persegi dengan gambar.
class SquareTile extends StatelessWidget {
  /// Path ke gambar yang akan ditampilkan.
  final String imagePath;

  /// Konstruktor yang membutuhkan [imagePath] dan menerima [key] sebagai parameter opsional.
  const SquareTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Membuat container dengan padding, border, dan background color.
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white), // Border putih.
        borderRadius: BorderRadius.circular(16), // Border radius 16.
        color: Colors.grey[200], // Warna background abu-abu.
      ),
      // Menampilkan gambar dari asset dengan tinggi tetap.
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}
