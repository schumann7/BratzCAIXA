import 'package:flutter/material.dart';

class UnitValueDisplay extends StatelessWidget {
  final double value;

  const UnitValueDisplay({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7DFF),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 20, left: 95),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Valor Unitário',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 30,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}