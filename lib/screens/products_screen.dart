import 'package:bratzcaixa/components/header.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bratzcaixa/screens/login_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(),
            const Expanded(child: ProductsPageBody()),
          ],
        ),
      ),
    );
  }
}

class ProductsPageBody extends StatefulWidget {
  const ProductsPageBody({super.key});

  static const Color mustardYellow = Color(0xE6E6B23A);

  @override
  State<ProductsPageBody> createState() => _ProductsPageBodyState();
}

class _ProductsPageBodyState extends State<ProductsPageBody> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _brandController = TextEditingController(); // Novo
  final TextEditingController _purchaseValueController = TextEditingController(); // Novo
  final TextEditingController _saleValueController = TextEditingController(); // Novo
  final TextEditingController _expirationDateController = TextEditingController(); // Novo

  List<dynamic> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _itemController.dispose();
    _brandController.dispose();
    _purchaseValueController.dispose();
    _saleValueController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }
  
  // --- Funções de Requisição à API ---

  Future<void> _fetchProducts({String? searchQuery}) async {
    if (globalToken == null) {
      _showError('Usuário não autenticado. Faça o login primeiro.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final Uri url;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url = Uri.http('localhost:5000', '/bratz/products', {'item': searchQuery});
    } else {
      url = Uri.http('localhost:5000', '/bratz/products');
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
          _products = responseData['data']['products'] as List<dynamic>;
          _isLoading = false;
        });
      } else {
        _showError('Falha ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Ocorreu um erro de rede: $e');
    }
  }
  
  void _showError(String message) {
    setState(() {
      _error = message;
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coluna esquerda: Título, busca e botões
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Produtos',
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
                          controller: _searchController,
                          style: const TextStyle(color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: 'Buscar por nome ou marca',
                            filled: true,
                            fillColor: Color(0xFFFCFEF2),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          onSubmitted: (value) => _fetchProducts(searchQuery: value),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _fetchProducts(searchQuery: _searchController.text),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  )
                  
                ],
              ),
            ),

            const SizedBox(width: 24),

            // Painel de listagem à direita
            Expanded(
              flex: 4,
              child: Container(
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
                    // Cabeçalho amarelo
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: const BoxDecoration(
                        color: ProductsPageBody.mustardYellow,
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
                    // Tabela de dados
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator(color: ProductsPageBody.mustardYellow))
                          : _error != null
                          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.black54)))
                          : DataTable(
                              columns: const [
                                DataColumn(label: Text('Item')),
                                DataColumn(label: Text('Marca')),
                                DataColumn(label: Text('Preço')),
                                DataColumn(label: Text('Validade')),
                              ],
                              rows: _products.map<DataRow>((product) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(product['item'] ?? 'N/A')),
                                    DataCell(Text(product['brand'] ?? 'N/A')),
                                    DataCell(Text(product['sale_value']?.toString() ?? 'N/A')),
                                    DataCell(Text(product['expiration_date'] ?? 'N/A')),
                                  ],
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}