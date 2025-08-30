import 'package:flutter/material.dart';

class ProductCartList extends StatelessWidget {
  final bool isLoading;
  final List<Map<String, dynamic>> cartItems;
  final ValueSetter<int> onRemoveItem;

  const ProductCartList({
    super.key,
    required this.isLoading,
    required this.cartItems,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(230),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF2E7DFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              'Lista de Produtos',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2E7DFF),
                    ),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      columns: const [
                        DataColumn(label: Text('Item')),
                        DataColumn(label: Text('Código')),
                        DataColumn(label: Text('Qtd.')),
                        DataColumn(label: Text('Valor')),
                        DataColumn(label: Text('Total')),
                        DataColumn(label: Text('Ações')),
                      ],
                      rows: cartItems.map<DataRow>((item) {
                        final total = item['sale_value'] * item['quantity'];
                        return DataRow(
                          cells: [
                            DataCell(Text(item['item'] ?? 'N/A')),
                            DataCell(Text(item['id']?.toString() ?? 'N/A')),
                            DataCell(Text(item['quantity'].toString())),
                            DataCell(Text(item['sale_value']?.toStringAsFixed(2) ?? 'N/A')),
                            DataCell(Text(total.toStringAsFixed(2))),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => onRemoveItem(item['id']),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}