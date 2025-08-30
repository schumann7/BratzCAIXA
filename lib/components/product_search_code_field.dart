// lib/components/product_search_code_field.dart

import 'package:flutter/material.dart';

class ProductSearchCodeField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const ProductSearchCodeField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      width: 400,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7DFF),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Código de Barras',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 1.0,
            ),
          ),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              hintText: 'Buscar por código',
              filled: true,
              fillColor: Color(0xFFFCFEF2),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            onSubmitted: onSubmitted,
          ),
        ],
      ),
    );
  }
}