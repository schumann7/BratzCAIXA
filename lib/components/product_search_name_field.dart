import 'package:flutter/material.dart';

class ProductSearchNameField extends StatelessWidget {
  final LayerLink layerLink;
  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const ProductSearchNameField({
    super.key,
    required this.layerLink,
    required this.controller,
    required this.isLoading,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: const Color(0xFF2E7DFF),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Produto',
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
              decoration: InputDecoration(
                hintText: isLoading ? 'Carregando produtos...' : 'Buscar por nome',
                filled: true,
                fillColor: const Color(0xFFFCFEF2),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}