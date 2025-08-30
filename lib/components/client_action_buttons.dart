import 'package:flutter/material.dart';

class ClientActionButtons extends StatelessWidget {
  final VoidCallback onAddNew;
  final VoidCallback onRemoveSelected;

  const ClientActionButtons({
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
            "+ Novo Cliente",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 50),
        ElevatedButton(
          onPressed: onRemoveSelected,
          style: _buttonStyle(),
          child: const Text(
            "- Remover Cliente",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
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
        return const Size(200, 75);
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        return const Color(0xFF36CDEB);
      }),
    );
  }
}