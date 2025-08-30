import 'package:bratzcaixa/components/header.dart';
import 'package:bratzcaixa/services/api_service.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [HeaderBar(), Expanded(child: ProductsPageBody())],
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
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _purchaseValueController =
      TextEditingController();
  final TextEditingController _saleValueController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();

  List<dynamic> _products = [];
  bool _isLoading = true;
  String? _error;
  int? _selectedProductId;

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

  Future<void> _fetchProducts({String? searchQuery}) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _selectedProductId = null;
    });

    try {
      final productsData = await _apiService.fetchProducts(
        searchQuery: searchQuery,
      );
      if (!mounted) return;
      setState(() {
        _products = productsData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  Future<void> _createProduct() async {
    final productData = {
      'item': _itemController.text,
      'brand': _brandController.text.isEmpty ? null : _brandController.text,
      'purchase_value': double.tryParse(_purchaseValueController.text),
      'sale_value': double.tryParse(_saleValueController.text),
      'expiration_date':
          _expirationDateController.text.isEmpty
              ? null
              : _expirationDateController.text,
    };

    try {
      await _apiService.createProduct(productData);
      _showSuccess('Produto criado com sucesso!');
      _clearForm();
      _fetchProducts();
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _deleteProduct(int productId) async {
    try {
      await _apiService.deleteProduct(productId);
      _showSuccess('Produto removido com sucesso!');
      _fetchProducts();
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

  void _clearForm() {
    _itemController.clear();
    _brandController.clear();
    _purchaseValueController.clear();
    _saleValueController.clear();
    _expirationDateController.clear();
  }

  void _showCreateProductDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Novo Produto'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(labelText: 'Item*'),
                  ),
                  TextField(
                    controller: _brandController,
                    decoration: const InputDecoration(labelText: 'Marca'),
                  ),
                  TextField(
                    controller: _purchaseValueController,
                    decoration: const InputDecoration(
                      labelText: 'Valor de Compra',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _saleValueController,
                    decoration: const InputDecoration(
                      labelText: 'Valor de Venda*',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _expirationDateController,
                    decoration: const InputDecoration(
                      labelText: 'Validade (DD-MM-AAAA)',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_itemController.text.isEmpty ||
                      _saleValueController.text.isEmpty) {
                    _showError('Item e Valor de Venda são obrigatórios.');
                  } else {
                    _createProduct();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmationDialog() {
    if (_selectedProductId == null) {
      _showError('Nenhum produto selecionado para remover.');
      return;
    }
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar Remoção'),
            content: const Text(
              'Tem certeza que deseja remover o produto selecionado?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteProduct(_selectedProductId!);
                  Navigator.of(context).pop();
                },
                child: const Text('Confirmar'),
              ),
            ],
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
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          onSubmitted:
                              (value) => _fetchProducts(searchQuery: value),
                        ),
                      ),
                      IconButton(
                        onPressed:
                            () => _fetchProducts(
                              searchQuery: _searchController.text,
                            ),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _showCreateProductDialog,
                        child: const Text('+ Novo Produto'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _showDeleteConfirmationDialog,
                        child: const Text('- Remover Produto'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(width: 24),
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
                    Expanded(
                      child:
                          _isLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: ProductsPageBody.mustardYellow,
                                ),
                              )
                              : _error != null
                              ? Center(
                                child: Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              )
                              : SingleChildScrollView(
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Item')),
                                    DataColumn(label: Text('Marca')),
                                    DataColumn(label: Text('Preço')),
                                    DataColumn(label: Text('Validade')),
                                  ],
                                  rows:
                                      _products.map<DataRow>((product) {
                                        return DataRow(
                                          selected:
                                              _selectedProductId ==
                                              product['id'],
                                          onSelectChanged: (isSelected) {
                                            setState(() {
                                              if (isSelected ?? false) {
                                                _selectedProductId =
                                                    product['id'];
                                              } else {
                                                _selectedProductId = null;
                                              }
                                            });
                                          },
                                          cells: [
                                            DataCell(
                                              Text(product['item'] ?? 'N/A'),
                                            ),
                                            DataCell(
                                              Text(product['brand'] ?? 'N/A'),
                                            ),
                                            DataCell(
                                              Text(
                                                'R\$ ${product['sale_value']?.toStringAsFixed(2) ?? 'N/A'}',
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                product['expiration_date'] ??
                                                    'N/A',
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
            ),
          ],
        ),
      ),
    );
  }
}
