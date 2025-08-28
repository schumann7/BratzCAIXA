import 'package:bratzcaixa/components/header.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bratzcaixa/screens/login_screen.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [const HeaderBar(), Expanded(child: ClientsPageBody())],
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
  final TextEditingController _clientSearchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<dynamic> _clients = [];
  bool _isLoading = true;
  String? _error;
  
  // NOVO: Estado para rastrear o cliente selecionado
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

  // --- Funções de Requisição à API ---

  Future<void> _fetchClients({String? searchQuery}) async {
    if (globalToken == null) {
      _showError('Usuário não autenticado. Faça o login primeiro.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      // Limpa a seleção ao recarregar a lista
      _selectedClientId = null;
      _selectedClientName = null;
    });

    final Uri url;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url = Uri.http('localhost:5000', '/bratz/clients', {'q': searchQuery});
    } else {
      url = Uri.http('localhost:5000', '/bratz/clients');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $globalToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _clients = responseData['data']['clients'] as List<dynamic>;
          _isLoading = false;
        });
      } else {
        _showError('Falha ao carregar clientes: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Ocorreu um erro de rede: $e');
    }
  }

  Future<void> _createClient() async {
    if (globalToken == null) {
      _showError('Usuário não autenticado.');
      return;
    }

    final Map<String, dynamic> clientData = {
      'name': _nameController.text,
      'cpf': _cpfController.text,
      'phone': _phoneController.text.isEmpty ? null : _phoneController.text,
      'notes': _notesController.text.isEmpty ? null : _notesController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/bratz/clients'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $globalToken',
        },
        body: jsonEncode(clientData),
      );

      if (response.statusCode == 201) {
        _showSuccess('Cliente criado com sucesso!');
        _fetchClients();
      } else {
        final errorResponse = json.decode(response.body);
        _showError('Erro ao criar cliente: ${errorResponse['message']}');
      }
    } catch (e) {
      _showError('Ocorreu um erro de rede: $e');
    }
  }

  Future<void> _removeClient(int clientId) async {
    if (globalToken == null) {
      _showError('Usuário não autenticado.');
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:5000/bratz/clients/$clientId'),
        headers: {
          'Authorization': 'Bearer $globalToken',
        },
      );

      if (response.statusCode == 200) {
        _showSuccess('Cliente removido com sucesso!');
        _fetchClients();
      } else {
        final errorResponse = json.decode(response.body);
        _showError('Erro ao remover cliente: ${errorResponse['message']}');
      }
    } catch (e) {
      _showError('Ocorreu um erro de rede: $e');
    }
  }

  // --- Funções Auxiliares de UI ---

  void _showError(String message) {
    setState(() {
      _error = message;
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCreateClientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Novo Cliente"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _cpfController,
                  decoration: const InputDecoration(labelText: 'CPF'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefone (Opcional)'),
                ),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Observações (Opcional)'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
                _nameController.clear();
                _cpfController.clear();
                _phoneController.clear();
                _notesController.clear();
              },
            ),
            ElevatedButton(
              child: const Text("Salvar"),
              onPressed: () {
                if (_cpfController.text.length < 11) {
                  _showSuccess('CPF inválido. Deve ter 11 dígitos.');
                } else {
                  _createClient();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog() {
    // NOVO: Lógica do diálogo de confirmação
    if (_selectedClientId == null) {
      _showSuccess('Selecione um cliente para remover.');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Remoção"),
          content: Text("Tem certeza que deseja remover o cliente $_selectedClientName?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
                  const Text(
                    "Clientes Frequentes",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _clientSearchController,
                          decoration: const InputDecoration(
                            hintText: "Buscar por nome, CPF ou telefone",
                            filled: true,
                            fillColor: Color(0xFFFCFEF2),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide.none
                            ),
                          ),
                          onSubmitted: (value) {
                             _fetchClients(searchQuery: value);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _fetchClients(searchQuery: _clientSearchController.text);
                        },
                        icon: const Icon(Icons.search, color: Colors.white, size: 30),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _showCreateClientDialog,
                        style: ButtonStyle(
                          shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
                            return const BeveledRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            );
                          }),
                          fixedSize: WidgetStateProperty.resolveWith<Size?>((states) {
                            return const Size(200, 75);
                          }),
                          backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                            return const Color(0xFF36CDEB);
                          }),
                        ),
                        child: const Text(
                          "+ Novo Cliente",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 50,),
                      ElevatedButton(
                        onPressed: _showConfirmationDialog, // Chamada para a nova função
                        style: ButtonStyle(
                          shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
                            return const BeveledRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            );
                          }),
                          fixedSize: WidgetStateProperty.resolveWith<Size?>((states) {
                            return const Size(200, 75);
                          }),
                          backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                            return const Color(0xFF36CDEB);
                          }),
                        ),
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
                  ),
                ],
              ),
            ),
            Container(
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
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator(color: Colors.white,))
                          : _error != null
                          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.white)))
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
                                DataColumn(label: Text('Ações')),
                              ],
                              rows: _clients.map<DataRow>((client) {
                                final isSelected = _selectedClientId == client['id'];
                                return DataRow(
                                  color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                    if (isSelected) {
                                      return Colors.grey[500];
                                    }
                                    return null;
                                  }),
                                  selected: isSelected,
                                  onSelectChanged: (selected) {
                                    setState(() {
                                      _selectedClientId = selected! ? client['id'] as int? : null;
                                      _selectedClientName = selected ? client['name'] as String? : null;
                                    });
                                  },
                                  cells: [
                                    DataCell(Text(client['name'] ?? 'N/A')),
                                    DataCell(Text(client['cpf'] ?? 'N/A')),
                                    DataCell(Text(client['phone'] ?? 'N/A')),
                                    DataCell(
                                      ElevatedButton(
                                        onPressed: () {
                                          _showSuccess('Aplicado o desconto do cliente ${client['name']}');
                                        },
                                        child: const Text("Desconto"),
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
            ),
          ],
        ),
      ),
    );
  }
}