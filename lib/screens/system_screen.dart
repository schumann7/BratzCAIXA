import 'package:flutter/material.dart';
import 'package:bratzcaixa/components/header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bratzcaixa/screens/login_screen.dart';
import 'dart:async';

class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [const HeaderBar(), Expanded(child: SystemPageBody())],
        ),
      ),
    );
  }
}

class SystemPageBody extends StatefulWidget {
  const SystemPageBody({super.key});

  @override
  State<SystemPageBody> createState() => _SystemPageBodyState();
}

class _SystemPageBodyState extends State<SystemPageBody> {
  // --- Controladores e Estado ---
  final TextEditingController _searchControllerName = TextEditingController();
  final TextEditingController _searchControllerCode = TextEditingController();

  // NOVO: Link para conectar o campo de busca ao dropdown
  final LayerLink _layerLink = LayerLink();

  Map<String, dynamic>? _currentProduct;
  double _subtotalValue = 0.0;
  bool _isLoading = true;
  final List<Map<String, dynamic>> _cartItems = [];
  List<dynamic> _allProducts = [];
  List<dynamic> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
  }

  @override
  void dispose() {
    _searchControllerName.dispose();
    _searchControllerCode.dispose();
    super.dispose();
  }

  // --- Funções de API e Lógica de Carrinho (sem alterações) ---
  Future<void> _fetchAllProducts() async {
    if (globalToken == null) {
      _showError('Usuário não autenticado.');
      return;
    }
    try {
      final response = await http.get(
        Uri.http('localhost:5000', '/bratz/products'),
        headers: {'Authorization': 'Bearer $globalToken'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> products =
            json.decode(response.body)['data']['products'];
        setState(() {
          _allProducts = products;
          _isLoading = false;
        });
      } else {
        _showError('Erro ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Ocorreu um erro de rede: $e');
    }
  }

  void _performLocalSearch(String query) {
    if (query.isEmpty) {
      setState(() => _filteredProducts = []);
      return;
    }
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final productName = product['item']?.toLowerCase() ?? '';
        return productName.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _fetchProductById(String id) async {
    if (globalToken == null) {
      _showError('Usuário não autenticado.');
      return;
    }
    if (id.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.http('localhost:5000', '/bratz/products/$id'),
        headers: {'Authorization': 'Bearer $globalToken'},
      );
      if (response.statusCode == 200) {
        final product = json.decode(response.body)['data'];
        _addItemToCart(product);
        _showSuccess('Produto encontrado e adicionado ao carrinho!');
      } else {
        _showError('Produto com ID "$id" não encontrado.');
      }
    } catch (e) {
      _showError('Ocorreu um erro de rede: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _resetSearch();
      });
    }
  }

  void _addItemToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add({
        'id': product['id'],
        'item': product['item'],
        'sale_value': product['sale_value'],
        'quantity': 1,
        'code': product['brand'],
        'description': 'N/A',
      });
      _calculateSubtotal();
    });
  }

  void _calculateSubtotal() {
    double sum = 0.0;
    for (var item in _cartItems) {
      sum += (item['sale_value'] * item['quantity']);
    }
    setState(() => _subtotalValue = sum);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    setState(() => _isLoading = false);
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _resetSearch() {
    _searchControllerName.clear();
    _searchControllerCode.clear();
    FocusScope.of(context).unfocus();
    setState(() => _filteredProducts = []);
  }

  // --- Widgets do layout ---

  Widget _titleBar() {
    return Container(
      height: 44,
      width: 700,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7DFF),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      alignment: Alignment.center,
      child: const Text(
        'CAIXA ABERTO',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // ALTERADO: Envolvido com CompositedTransformTarget
  Widget _productSearchName() {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: const Color(0xFF2E7DFF),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
                color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Produto',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 1.0,
              ),
            ),
            TextField(
              controller: _searchControllerName,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText:
                    _isLoading ? 'Carregando produtos...' : 'Buscar por nome',
                filled: true,
                fillColor: const Color(0xFFFCFEF2),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              onChanged: _performLocalSearch,
            ),
          ],
        ),
      ),
    );
  }

  Widget _productSearchCode() {
    return Container(
      height: 108,
      width: 400,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7DFF),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Código de Barras',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 1.0,
            ),
          ),
          TextField(
            controller: _searchControllerCode,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              hintText: 'Buscar por código',
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
            onSubmitted: (value) => _fetchProductById(value),
          ),
        ],
      ),
    );
  }

  Widget _productValue() {
    final lastItemValue = _cartItems.isNotEmpty ? _cartItems.last['sale_value'] : 0.0;
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
            'R\$ ${lastItemValue.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 30,
              letterSpacing: 1.0,
            ),
          )
        ],
      ),
    );
  }
  
  // ... (subtotal, receipt, change)
  Widget _subtotal() {
    return Expanded(
      flex: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2E7DFF),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 20, left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subtotal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              'R\$ ${_subtotalValue.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 30,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receipt() {
    return Expanded(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF2E7DFF),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 20, left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Recibo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              'R\$ 0,00',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 30,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _change() {
    return Expanded(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF2E7DFF),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 20, left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Troco',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              'R\$ 0,00',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 30,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // REESCRITO: Agora usa CompositedTransformFollower para se posicionar
  Widget _buildSearchResultsOverlay() {
    return CompositedTransformFollower(
      link: _layerLink,
      showWhenUnlinked: false,
      // Deslocamento para aparecer abaixo do campo de busca.
      offset: const Offset(0.0, 108.0), 
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 400, // Mesma largura do campo de busca
          constraints: const BoxConstraints(maxHeight: 220),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return ListTile(
                title: Text(product['item'] ?? 'N/A'),
                subtitle: Text(
                    'R\$ ${product['sale_value']?.toStringAsFixed(2) ?? 'N/A'}'),
                onTap: () {
                  _addItemToCart(product);
                  _resetSearch();
                  _showSuccess('Produto adicionado ao carrinho!');
                },
              );
            },
          ),
        ),
      ),
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
      child: Stack(
        children: [
          // Camada 1: Seu layout original COMPLETO
          Padding(
            padding: const EdgeInsets.all(36.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleBar(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_productSearchName(), _productValue()],
                    ),
                    _productSearchCode(),
                  ],
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 12,
                                    offset: Offset(0, 6))
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2E7DFF),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12)),
                                ),
                                child: const Text('Lista de Produtos',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700)),
                              ),
                              _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: Color(0xFF2E7DFF)))
                                  : Expanded(
                                      child: SingleChildScrollView(
                                        child: DataTable(
                                          decoration: const BoxDecoration(
                                              color: Colors.white),
                                          columns: const [
                                            DataColumn(label: Text('Item')),
                                            DataColumn(label: Text('Código')),
                                            DataColumn(label: Text('Descrição')),
                                            DataColumn(label: Text('Valor')),
                                            DataColumn(label: Text('Total')),
                                          ],
                                          rows:
                                              _cartItems.map<DataRow>((item) {
                                            final total = item['sale_value'] *
                                                item['quantity'];
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(item['item'] ?? 'N/A')),
                                                DataCell(Text(item['id']?.toString() ?? 'N/A')),
                                                DataCell(Text(item['brand'] ?? 'N/A')),
                                                DataCell(Text(item['sale_value']?.toStringAsFixed(2) ?? 'N/A')),
                                                DataCell(Text(total.toStringAsFixed(2))),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      _subtotal(),
                      Row(children: [
                        _receipt(),
                        const SizedBox(width: 20),
                        _change()
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_filteredProducts.isNotEmpty) _buildSearchResultsOverlay(),
        ],
      ),
    );
  }
}