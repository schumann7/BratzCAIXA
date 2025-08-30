import 'package:flutter/material.dart';

class TotalsDisplay extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double total;
  final String? clientName;

  const TotalsDisplay({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.total,
    this.clientName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: TextStyle(color: Colors.white, fontSize: 16)),
              Text('R\$ ${subtotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Visibility(
            visible: discount > 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Desconto (${clientName ?? ''})', style: const TextStyle(color: Colors.lightGreenAccent, fontSize: 16)),
                Text('- R\$ ${discount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.lightGreenAccent, fontSize: 16)),
              ],
            ),
          ),
          const Divider(color: Colors.white54, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL A PAGAR', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text('R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}