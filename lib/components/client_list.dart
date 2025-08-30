import 'package:flutter/material.dart';

class ClientList extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<dynamic> clients;
  final int? selectedClientId;
  final Function(Map<String, dynamic> client, bool? isSelected)
  onSelectionChanged;

  const ClientList({
    super.key,
    required this.isLoading,
    this.error,
    required this.clients,
    this.selectedClientId,
    required this.onSelectionChanged,
  });

  String _formatDiscounts(Map<String, dynamic>? discounts) {
    if (discounts == null || discounts.isEmpty) {
      return 'Nenhum';
    }
    return discounts.entries
        .map((entry) => '${entry.key}: ${entry.value}%')
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      decoration: const BoxDecoration(
        color: Color(0xFF36CDEB),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Lista de Clientes",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 800,
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : error != null
                      ? Center(
                        child: Text(
                          error!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                      : DataTable(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFCFEF2),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        columns: const [
                          DataColumn(label: Text('Nome')),
                          DataColumn(label: Text('CPF')),
                          DataColumn(label: Text('Telefone')),
                          DataColumn(label: Text('Descontos')),
                        ],
                        rows:
                            clients.map<DataRow>((client) {
                              final isSelected =
                                  selectedClientId == client['id'];
                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>((
                                  Set<WidgetState> states,
                                ) {
                                  if (isSelected) {
                                    return Colors.blueGrey.withOpacity(0.3);
                                  }
                                  return null;
                                }),
                                selected: isSelected,
                                onSelectChanged: (selected) {
                                  onSelectionChanged(client, selected);
                                },
                                cells: [
                                  DataCell(Text(client['name'] ?? 'N/A')),
                                  DataCell(Text(client['cpf'] ?? 'N/A')),
                                  DataCell(Text(client['phone'] ?? 'N/A')),
                                  DataCell(
                                    Tooltip(
                                      message: _formatDiscounts(
                                        client['discounts'],
                                      ),
                                      child: Text(
                                        _formatDiscounts(client['discounts']),
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
