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
  // O controlador do campo de busca deve ser gerenciado pelo estado
  final TextEditingController _clientSearchController = TextEditingController();

  // Estado para os dados da API
  List<dynamic> _clients = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Inicia a requisição assim que a tela é criada
    _fetchClients();
  }

  @override
  void dispose() {
    // Importante para evitar vazamentos de memória
    _clientSearchController.dispose();
    super.dispose();
  }

  Future<void> _fetchClients() async {
    // Adiciona o token na requisição
    if (globalToken == null) {
      setState(() {
        _error = 'Usuário não autenticado. Faça o login primeiro.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/bratz/clients'),
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
        setState(() {
          _error = 'Falha ao carregar clientes: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Ocorreu um erro de rede: $e';
        _isLoading = false;
      });
    }
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _clientSearchController,
                          decoration: const InputDecoration(
                            hintText: "Buscar por nome, CPF ou telefone",
                            filled: true,
                            fillColor: Color(0xFFFCFEF2),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search, color: Colors.white, size: 30),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
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
                        onPressed: () {},
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
                      // NOVO: Lógica para mostrar o estado da requisição
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
                                return DataRow(
                                  cells: [
                                    DataCell(Text(client['name'] ?? 'N/A')),
                                    DataCell(Text(client['cpf'] ?? 'N/A')),
                                    DataCell(Text(client['phone'] ?? 'N/A')),
                                    DataCell(
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Ação"),
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