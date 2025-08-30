import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<dynamic> products;
  final int? selectedProductId;
  final Function(Map<String, dynamic> product, bool? isSelected)
  onSelectionChanged;
  final Color headerColor;

  const ProductList({
    super.key,
    required this.isLoading,
    this.error,
    required this.products,
    this.selectedProductId,
    required this.onSelectionChanged,
    this.headerColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
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
          Expanded(
            child:
                isLoading
                    ? Center(
                      child: CircularProgressIndicator(color: headerColor),
                    )
                    : error != null
                    ? Center(
                      child: Text(
                        error!,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    )
                    : SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Item')),
                          DataColumn(label: Text('Marca')),
                          DataColumn(label: Text('Categoria')),
                          DataColumn(label: Text('Preço')),
                          DataColumn(label: Text('Qtd. Estoque')),
                          DataColumn(label: Text('Validade')),
                        ],
                        rows:
                            products.map<DataRow>((product) {
                              return DataRow(
                                selected: selectedProductId == product['id'],
                                onSelectChanged: (isSelected) {
                                  onSelectionChanged(product, isSelected);
                                },
                                cells: [
                                  DataCell(Text(product['item'] ?? 'N/A')),
                                  DataCell(Text(product['brand'] ?? 'N/A')),
                                  DataCell(Text(product['category'] ?? 'N/A')),
                                  DataCell(
                                    Text(
                                      'R\$ ${product['sale_value']?.toStringAsFixed(2) ?? 'N/A'}',
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product['quantity_in_stock']
                                              ?.toString() ??
                                          '0',
                                    ),
                                  ),
                                  DataCell(
                                    Text(product['expiration_date'] ?? 'N/A'),
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
