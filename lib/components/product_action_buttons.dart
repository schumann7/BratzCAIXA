import 'package:flutter/material.dart';

class ProductActionButtons extends StatelessWidget {
  final VoidCallback onAddNew;
  final VoidCallback onRemoveSelected;

  const ProductActionButtons({
    super.key,
    required this.onAddNew,
    required this.onRemoveSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: onAddNew,
          style: _buttonStyle(),
          child: const Text(
            "+ Novo Produto",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 50),
        ElevatedButton(
          onPressed: onRemoveSelected,
          style: _buttonStyle(),
          child: const Text(
            "- Remover Produto",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
        return const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        );
      }),
      fixedSize: WidgetStateProperty.resolveWith<Size?>((states) {
        return const Size(150, 75);
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        return const Color(0xE6E6B23A);
      }),
    );
  }
}