import 'package:bratzcaixa/components/header.dart';
import 'package:bratzcaixa/components/product_action_buttons.dart';
import 'package:bratzcaixa/components/product_list.dart';
import 'package:bratzcaixa/components/product_search_header.dart';
import 'package:bratzcaixa/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _stockQuantityController =
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
    _categoryController.dispose();
    _stockQuantityController.dispose();
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

  Future<void> _createProduct(
    Map<String, dynamic> productData, {
    int? stockId,
    int? quantity,
  }) async {
    try {
      final newProduct = await _apiService.createProduct(productData);
      _showSuccess('Produto "${newProduct['item']}" criado com sucesso!');

      if (stockId != null && quantity != null && quantity > 0) {
        final newProductId = newProduct['id'];
        await _addStock(
          productId: newProductId,
          stockId: stockId,
          quantity: quantity,
        );
      }

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

  Future<void> _addStock({
    required int productId,
    required int stockId,
    required int quantity,
  }) async {
    try {
      await _apiService.addStock(
        productId: productId,
        stockId: stockId,
        quantity: quantity,
      );
      _showSuccess('Estoque adicionado com sucesso!');
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _clearForm() {
    _itemController.clear();
    _brandController.clear();
    _purchaseValueController.clear();
    _saleValueController.clear();
    _expirationDateController.clear();
    _categoryController.clear();
    _stockQuantityController.clear();
  }

  void _showCreateProductDialog() async {
    _clearForm();
    List<dynamic> stocks = [];
    try {
      stocks = await _apiService.fetchStocks();
    } catch (e) {
      _showError(e.toString());
    }

    int? selectedStockId;
    if (stocks.isNotEmpty) {
      selectedStockId = stocks.first['id'];
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Novo Produto'),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
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
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                        ),
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
                      const Divider(height: 30),
                      const Text(
                        'Estoque Inicial (Opcional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<int>(
                              isExpanded: true,
                              value: selectedStockId,
                              hint: const Text('Local de Estoque'),
                              items:
                                  stocks.map<DropdownMenuItem<int>>((stock) {
                                    return DropdownMenuItem<int>(
                                      value: stock['id'],
                                      child: Text(stock['name']),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setDialogState(() => selectedStockId = value);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _stockQuantityController,
                              decoration: const InputDecoration(
                                labelText: 'Quantidade',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                      final productData = {
                        'item': _itemController.text,
                        'brand':
                            _brandController.text.isEmpty
                                ? null
                                : _brandController.text,
                        'category':
                            _categoryController.text.isEmpty
                                ? null
                                : _categoryController.text,
                        'purchase_value': double.tryParse(
                          _purchaseValueController.text,
                        ),
                        'sale_value': double.tryParse(
                          _saleValueController.text,
                        ),
                        'expiration_date':
                            _expirationDateController.text.isEmpty
                                ? null
                                : _expirationDateController.text,
                      };
                      _createProduct(
                        productData,
                        stockId: selectedStockId,
                        quantity: int.tryParse(_stockQuantityController.text),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
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
                  ProductSearchHeader(
                    title: 'Produtos',
                    searchController: _searchController,
                    onSearch: (value) => _fetchProducts(searchQuery: value),
                  ),
                  const Spacer(),
                  ProductActionButtons(
                    onAddNew: _showCreateProductDialog,
                    onRemoveSelected: _showDeleteConfirmationDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 4,
              child: ProductList(
                isLoading: _isLoading,
                error: _error,
                products: _products,
                selectedProductId: _selectedProductId,
                onSelectionChanged: (product, isSelected) {
                  setState(() {
                    if (isSelected ?? false) {
                      _selectedProductId = product['id'];
                    } else {
                      _selectedProductId = null;
                    }
                  });
                },
                headerColor: ProductsPageBody.mustardYellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
