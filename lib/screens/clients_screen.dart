import 'package:bratzcaixa/components/client_action_buttons.dart';
import 'package:bratzcaixa/components/client_list.dart';
import 'package:bratzcaixa/components/client_search_header.dart';
import 'package:bratzcaixa/components/header.dart';
import 'package:bratzcaixa/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [HeaderBar(), Expanded(child: ClientsPageBody())],
        ),
      ),
    );
  }
}

class ClientsPageBody extends StatefulWidget {
  const ClientsPageBody({super.key});

  @override
  State<ClientsPageBody> createState() => _ClientsPageBodyState();
}

class _ClientsPageBodyState extends State<ClientsPageBody> {
  final ApiService _apiService = ApiService();
  final TextEditingController _clientSearchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<dynamic> _clients = [];
  bool _isLoading = true;
  String? _error;
  int? _selectedClientId;
  String? _selectedClientName;

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  @override
  void dispose() {
    _clientSearchController.dispose();
    _nameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchClients({String? searchQuery}) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _selectedClientId = null;
      _selectedClientName = null;
    });

    try {
      final clientsData = await _apiService.fetchClients(
        searchQuery: searchQuery,
      );
      if (!mounted) return;
      setState(() {
        _clients = clientsData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  Future<void> _createClient({required Map<String, double> discounts}) async {
    final Map<String, dynamic> clientData = {
      'name': _nameController.text,
      'cpf': _cpfController.text,
      'phone': _phoneController.text.isEmpty ? null : _phoneController.text,
      'notes': _notesController.text.isEmpty ? null : _notesController.text,
      'discounts': discounts,
    };

    try {
      await _apiService.createClient(clientData);
      _showSuccess('Cliente criado com sucesso!');
      _fetchClients();
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _removeClient(int clientId) async {
    try {
      await _apiService.deleteClient(clientId);
      _showSuccess('Cliente removido com sucesso!');
      _fetchClients();
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() {
      _error = message;
      _isLoading = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCreateClientDialog() {
    _nameController.clear();
    _cpfController.clear();
    _phoneController.clear();
    _notesController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Controllers para os campos de desconto
        final categoryController = TextEditingController();
        final percentageController = TextEditingController();

        // StatefulBuilder para gerenciar o estado interno do Dialog
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Map<String, double> discounts = {};

            return AlertDialog(
              title: const Text("Novo Cliente"),
              content: SizedBox(
                width: 500, // Aumenta a largura do Dialog
                child: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nome*'),
                      ),
                      TextField(
                        controller: _cpfController,
                        decoration: const InputDecoration(labelText: 'CPF*'),
                      ),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone (Opcional)',
                        ),
                      ),
                      TextField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Observações (Opcional)',
                        ),
                      ),
                      const Divider(height: 30),
                      const Text(
                        'Gerenciar Descontos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: categoryController,
                              decoration: const InputDecoration(
                                labelText: 'Categoria (ex: geral)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: percentageController,
                              decoration: const InputDecoration(
                                labelText: 'Porcentagem %',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              final category =
                                  categoryController.text.trim().toLowerCase();
                              final percentage = double.tryParse(
                                percentageController.text,
                              );
                              if (category.isNotEmpty && percentage != null) {
                                setDialogState(() {
                                  discounts[category] = percentage;
                                });
                                categoryController.clear();
                                percentageController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children:
                            discounts.entries.map((entry) {
                              return Chip(
                                label: Text('${entry.key}: ${entry.value}%'),
                                onDeleted: () {
                                  setDialogState(() {
                                    discounts.remove(entry.key);
                                  });
                                },
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancelar"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text("Salvar"),
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _cpfController.text.isEmpty) {
                      _showError('Nome e CPF são obrigatórios.');
                    } else {
                      _createClient(discounts: discounts); // Passa os descontos
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showConfirmationDialog() {
    if (_selectedClientId == null) {
      _showSuccess('Selecione um cliente para remover.');
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Remoção"),
          content: Text(
            "Tem certeza que deseja remover o cliente $_selectedClientName?",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Confirmar"),
              onPressed: () {
                _removeClient(_selectedClientId!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B2B2B), Color(0xFF1F1F1F)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClientSearchHeader(
                    title: "Clientes Frequentes",
                    searchController: _clientSearchController,
                    onSearch: (value) {
                      _fetchClients(searchQuery: value);
                    },
                  ),
                  const Spacer(),
                  ClientActionButtons(
                    onAddNew: _showCreateClientDialog,
                    onRemoveSelected: _showConfirmationDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: ClientList(
                isLoading: _isLoading,
                error: _error,
                clients: _clients,
                selectedClientId: _selectedClientId,
                onSelectionChanged: (client, isSelected) {
                  setState(() {
                    if (isSelected ?? false) {
                      _selectedClientId = client['id'] as int?;
                      _selectedClientName = client['name'] as String?;
                    } else {
                      _selectedClientId = null;
                      _selectedClientName = null;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
