import 'package:flutter/material.dart';

class ReceiptDisplay extends StatelessWidget {
  final double value;

  const ReceiptDisplay({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7DFF),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 20, left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recibo',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 1.0,
            ),
          ),
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