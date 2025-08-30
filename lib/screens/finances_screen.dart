import 'package:bratzcaixa/components/header.dart';
import 'package:bratzcaixa/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinancesScreen extends StatelessWidget {
  const FinancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [HeaderBar(), Expanded(child: FinancesPageBody())],
        ),
      ),
    );
  }
}

class FinancesPageBody extends StatefulWidget {
  const FinancesPageBody({super.key});

  @override
  State<FinancesPageBody> createState() => _FinancesPageBodyState();
}

class _FinancesPageBodyState extends State<FinancesPageBody> {
  final ApiService _apiService = ApiService();
  final TextEditingController _dateController = TextEditingController();

  bool _isLoading = true;
  String? _error;
  List<dynamic> _allSales = [];
  List<dynamic> _filteredSales = [];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchSales();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _fetchSales() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final salesData = await _apiService.fetchMySales();
      if (!mounted) return;
      setState(() {
        _allSales = salesData;
        _filteredSales = salesData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    if (_selectedDate == null) {
      setState(() {
        _filteredSales = _allSales;
      });
      return;
    }

    final filtered =
        _allSales.where((sale) {
          final saleDate = DateTime.parse(sale['sell_time']);
          return saleDate.year == _selectedDate!.year &&
              saleDate.month == _selectedDate!.month &&
              saleDate.day == _selectedDate!.day;
        }).toList();

    setState(() {
      _filteredSales = filtered;
    });
  }

  void _clearFilter() {
    _dateController.clear();
    setState(() {
      _selectedDate = null;
      _filteredSales = _allSales;
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (result != null) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(result);
      setState(() {
        _selectedDate = result;
      });
      _applyFilter();
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildTitleBar(),
            const SizedBox(height: 16),
            _buildFilters(),
            const SizedBox(height: 16),
            Expanded(child: _buildTableArea()),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC40),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: const Text(
        'MINHAS VENDAS (ÚLTIMOS 7 DIAS)',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: TextField(
            controller: _dateController,
            decoration: InputDecoration(
              hintText: 'Filtrar por data',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _pickDate(context),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _clearFilter,
          child: const Text('Limpar Filtro'),
        ),
      ],
    );
  }

  Widget _buildTableArea() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (_filteredSales.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma venda encontrada.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(240),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Data/Hora')),
          DataColumn(label: Text('ID da Venda')),
          DataColumn(label: Text('Total (R\$)')),
          DataColumn(label: Text('Pagamento')),
        ],
        rows:
            _filteredSales.map((sale) {
              final saleTime = DateTime.parse(sale['sell_time']);

              // --- CORREÇÃO APLICADA AQUI ---
              final saleId =
                  sale['id']
                      as String?; // Pega o ID como uma String que pode ser nula
              final displayText =
                  saleId != null ? '#${saleId.substring(0, 8)}...' : 'ID N/A';

              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('dd/MM/yy HH:mm').format(saleTime))),
                  DataCell(
                    Tooltip(
                      message: saleId ?? 'ID Não Disponível',
                      child: Text(displayText),
                    ),
                  ),
                  DataCell(
                    Text(sale['total_value']?.toStringAsFixed(2) ?? '0.00'),
                  ),
                  DataCell(Text(sale['payment_method'] ?? 'N/A')),
                ],
              );
            }).toList(),
      ),
    );
  }
}
