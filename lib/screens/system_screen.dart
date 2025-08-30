import 'package:bratzcaixa/components/change_display.dart';
import 'package:bratzcaixa/components/header.dart';
import 'package:bratzcaixa/components/product_cart_list.dart';
import 'package:bratzcaixa/components/product_search_code_field.dart';
import 'package:bratzcaixa/components/product_search_name_field.dart';
import 'package:bratzcaixa/components/receipt_display.dart';
import 'package:bratzcaixa/components/totals_display.dart';
import 'package:bratzcaixa/components/unit_value_display.dart';
import 'package:bratzcaixa/services/api_service.dart';
import 'package:bratzcaixa/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [HeaderBar(), Expanded(child: SystemPageBody())],
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
  final ApiService _apiService = ApiService();
  final TextEditingController _searchControllerName = TextEditingController();
  final TextEditingController _searchControllerCode = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _valorRecebidoController =
      TextEditingController();
  final TextEditingController _clientSearchController = TextEditingController();

  double _subtotalValue = 0.0;
  double _discountValue = 0.0;
  double _totalValue = 0.0;
  bool _isLoading = true;
  final List<Map<String, dynamic>> _cartItems = [];
  List<dynamic> _allProducts = [];
  List<dynamic> _filteredProducts = [];

  Map<String, dynamic>? _selectedClient;
  double _valorRecebidoDisplay = 0.0;
  double _trocoDisplay = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
  }

  @override
  void dispose() {
    _searchControllerName.dispose();
    _searchControllerCode.dispose();
    _valorRecebidoController.dispose();
    _clientSearchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _apiService.fetchProducts();
      if (!mounted) return;
      setState(() {
        _allProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  void _performLocalSearch(String query) {
    if (query.isEmpty) {
      setState(() => _filteredProducts = []);
      return;
    }
    setState(() {
      _filteredProducts =
          _allProducts.where((product) {
            final productName = product['item']?.toLowerCase() ?? '';
            return productName.contains(query.toLowerCase());
          }).toList();
    });
  }

  Future<void> _fetchProductById(String id) async {
    if (id.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final product = await _apiService.fetchProductById(id);
      if (!mounted) return;
      _addItemToCart(product);
      _showSuccess('Produto encontrado e adicionado ao carrinho!');
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _resetSearch();
      });
    }
  }

  void _addItemToCart(Map<String, dynamic> product) {
    if (_cartItems.isEmpty) {
      setState(() {
        _valorRecebidoDisplay = 0.0;
        _trocoDisplay = 0.0;
      });
    }

    setState(() {
      final int availableStock = product['quantity_in_stock'] ?? 0;
      final existingIndex = _cartItems.indexWhere(
        (item) => item['id'] == product['id'],
      );
      int currentQuantityInCart = 0;
      if (existingIndex >= 0) {
        currentQuantityInCart = _cartItems[existingIndex]['quantity'];
      }

      if (currentQuantityInCart + 1 > availableStock) {
        _showError(
          'Estoque insuficiente para ${product['item']}. Disponível: $availableStock',
        );
        return;
      }

      if (existingIndex >= 0) {
        _cartItems[existingIndex]['quantity']++;
      } else {
        _cartItems.add({
          'id': product['id'],
          'item': product['item'],
          'sale_value': product['sale_value'],
          'brand': product['brand'],
          'quantity': 1,
          'quantity_in_stock': availableStock,
          'category': product['category'],
        });
      }
      _updateTotals();
    });
  }

  void _removeItemFromCart(int productId) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == productId);
      _updateTotals();
    });
  }

  void _updateTotals() {
    double newSubtotal = 0.0;
    double newDiscount = 0.0;

    for (var item in _cartItems) {
      final lineTotal = (item['sale_value'] * item['quantity']);
      newSubtotal += lineTotal;

      if (_selectedClient != null && _selectedClient!['discounts'] != null) {
        final Map<String, dynamic> discounts = _selectedClient!['discounts'];
        final String? itemCategory = item['category']?.toLowerCase();
        double percentage = 0.0;

        if (itemCategory != null && discounts.containsKey(itemCategory)) {
          percentage = discounts[itemCategory]?.toDouble() ?? 0.0;
        } else if (discounts.containsKey('geral')) {
          percentage = discounts['geral']?.toDouble() ?? 0.0;
        }

        if (percentage > 0) {
          newDiscount += lineTotal * (percentage / 100.0);
        }
      }
    }

    setState(() {
      _subtotalValue = newSubtotal;
      _discountValue = newDiscount;
      _totalValue = newSubtotal - newDiscount;
    });
  }

  Future<void> _registerSaleOnApi({
    required String paymentMethod,
    double? receivedValue,
    double? change,
  }) async {
    if (AuthService.profile == null) {
      _showError("Dados do caixa não encontrados. Faça o login novamente.");
      return;
    }

    final idCaixa = AuthService.profile!['register_number']?.toString();
    final operatorName = AuthService.profile!['operator_name'];

    if (idCaixa == null || operatorName == null) {
      _showError("Perfil do caixa incompleto. Contate um administrador.");
      return;
    }

    final List<Map<String, dynamic>> itemsPayload =
        _cartItems.map((item) {
          return {
            'product_id': item['id'],
            'product_name': item['item'],
            'quantity': item['quantity'],
            'unit_value': item['sale_value'],
            'total_value_item': item['sale_value'] * item['quantity'],
          };
        }).toList();

    final sellData = {
      'sell_id': const Uuid().v4(),
      'id_caixa': idCaixa,
      'operator': operatorName,
      'total_value': _totalValue,
      'payment_method': paymentMethod,
      'received_value': receivedValue,
      'change': change,
      'items': itemsPayload,
    };

    try {
      await _apiService.registerSell(sellData);
      setState(() {
        _cartItems.clear();
        _selectedClient = null;
        _valorRecebidoDisplay = receivedValue ?? 0.0;
        _trocoDisplay = change ?? 0.0;
        _updateTotals();
      });
      _showSuccess('Venda registrada com sucesso!');
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _showPaymentDialog() async {
    String selectedPaymentMethod = 'Dinheiro';
    _valorRecebidoController.clear();
    double troco = 0.0;
    bool isConfirmButtonEnabled = selectedPaymentMethod != 'Dinheiro';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void updateTotal() {
              final valorRecebido =
                  double.tryParse(_valorRecebidoController.text) ?? 0.0;
              if (selectedPaymentMethod == 'Dinheiro') {
                isConfirmButtonEnabled = valorRecebido >= _totalValue;
                troco =
                    isConfirmButtonEnabled ? valorRecebido - _totalValue : 0.0;
              } else {
                isConfirmButtonEnabled = true;
                troco = 0.0;
              }
            }

            return AlertDialog(
              title: const Text('Finalizar Venda'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Total a Pagar: R\$ ${_totalValue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Forma de Pagamento:'),
                    DropdownButton<String>(
                      value: selectedPaymentMethod,
                      isExpanded: true,
                      items:
                          [
                                'Dinheiro',
                                'Pix',
                                'Débito',
                                'Crédito',
                                'Vale',
                                'Cheque',
                              ]
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (String? newValue) => setDialogState(() {
                            selectedPaymentMethod = newValue!;
                            updateTotal();
                          }),
                    ),
                    if (selectedPaymentMethod == 'Dinheiro')
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          TextField(
                            controller: _valorRecebidoController,
                            decoration: const InputDecoration(
                              labelText: 'Valor Recebido',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (value) => setDialogState(updateTotal),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Troco: R\$ ${troco.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  onPressed:
                      isConfirmButtonEnabled
                          ? () {
                            Navigator.of(context).pop();
                            _registerSaleOnApi(
                              paymentMethod: selectedPaymentMethod,
                              receivedValue: double.tryParse(
                                _valorRecebidoController.text,
                              ),
                              change: troco,
                            );
                          }
                          : null,
                  child: const Text('Confirmar Pagamento'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showClientSearchDialog() async {
    _clientSearchController.clear();
    List<dynamic> foundClients = [];
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> search(String query) async {
              if (query.length < 2) {
                setDialogState(() => foundClients = []);
                return;
              }
              try {
                final result = await _apiService.fetchClients(
                  searchQuery: query,
                );
                setDialogState(() => foundClients = result);
              } catch (e) {
                // Silently fail
              }
            }

            return AlertDialog(
              title: const Text('Identificar Cliente'),
              content: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: _clientSearchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Buscar por nome ou CPF...',
                      ),
                      onChanged: search,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: foundClients.length,
                        itemBuilder: (context, index) {
                          final client = foundClients[index];
                          return ListTile(
                            title: Text(
                              client['name'] ?? 'Nome não encontrado',
                            ),
                            onTap: () {
                              setState(() {
                                _selectedClient = client;
                              });
                              _updateTotals();
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedClient = null;
                    });
                    _updateTotals();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Remover Cliente'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    setState(() => _isLoading = false);
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _resetSearch() {
    _searchControllerName.clear();
    _searchControllerCode.clear();
    FocusScope.of(context).unfocus();
    setState(() => _filteredProducts = []);
  }

  Widget _titleBar() => Container(
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

  Widget _buildClientButton() {
    return Container(
      width: 400,
      height: 40,
      margin: const EdgeInsets.only(top: 20),
      child: OutlinedButton.icon(
        icon: Icon(
          _selectedClient != null ? Icons.person : Icons.person_add,
          color: Colors.white,
        ),
        label: Text(
          _selectedClient != null
              ? _selectedClient!['name']
              : 'Identificar Cliente',
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: _showClientSearchDialog,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white54),
        ),
      ),
    );
  }

  Widget _finalizarVendaButton() => Container(
    width: 400,
    height: 60,
    margin: const EdgeInsets.only(top: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: _cartItems.isEmpty ? null : _showPaymentDialog,
      child: const Text(
        'Finalizar Venda',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _buildSearchResultsOverlay() => CompositedTransformFollower(
    link: _layerLink,
    showWhenUnlinked: false,
    offset: const Offset(0.0, 108.0),
    child: Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 400,
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
                'R\$ ${product['sale_value']?.toStringAsFixed(2) ?? 'N/A'}',
              ),
              trailing: Text('Estoque: ${product['quantity_in_stock'] ?? 0}'),
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

  @override
  Widget build(BuildContext context) {
    final lastItemValue =
        _cartItems.isNotEmpty ? _cartItems.last['sale_value'] : 0.0;

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
                      children: [
                        ProductSearchNameField(
                          layerLink: _layerLink,
                          controller: _searchControllerName,
                          isLoading: _isLoading,
                          onChanged: _performLocalSearch,
                          onSubmitted: (value) {
                            if (_filteredProducts.isNotEmpty) {
                              _addItemToCart(_filteredProducts.first);
                              _resetSearch();
                              _showSuccess('Produto adicionado ao carrinho!');
                            }
                          },
                        ),
                        UnitValueDisplay(value: lastItemValue),
                      ],
                    ),
                    ProductSearchCodeField(
                      controller: _searchControllerCode,
                      onSubmitted: _fetchProductById,
                    ),
                    _buildClientButton(),
                    _finalizarVendaButton(),
                  ],
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ProductCartList(
                          isLoading: _isLoading,
                          cartItems: _cartItems,
                          onRemoveItem: _removeItemFromCart,
                        ),
                      ),
                      TotalsDisplay(
                        subtotal: _subtotalValue,
                        discount: _discountValue,
                        total: _totalValue,
                        clientName: _selectedClient?['name'],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ReceiptDisplay(value: _valorRecebidoDisplay),
                          ),
                          const SizedBox(width: 20),
                          Expanded(child: ChangeDisplay(value: _trocoDisplay)),
                        ],
                      ),
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
