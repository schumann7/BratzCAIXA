import 'package:flutter/material.dart';
import 'package:bratzcaixa/components/header.dart';

class FinancesScreen extends StatefulWidget {
  const FinancesScreen({super.key});

  @override
  State<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  String _type = 'Entrada';

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2B2B2B), Color(0xFF1F1F1F)],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _titleBar(),
                          const SizedBox(height: 16),
                          _filtersRow(context),
                          const SizedBox(height: 16),
                          _tableArea(),
                          const SizedBox(height: 16),
                          _actionsRow(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC40),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3))],
      ),
      alignment: Alignment.center,
      child: const Text(
        'FINANCEIRO',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: 1.0),
      ),
    );
  }

  Widget _filtersRow(BuildContext context) {
    InputDecoration decoration(String hint) => InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
        );

    return Row(
      children: [
        SizedBox(
          width: 140,
          child: TextField(
            controller: _fromDateController,
            decoration: decoration('dd/mm/aaaa'),
            readOnly: true,
            onTap: () => _pickDate(context, _fromDateController),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 140,
          child: TextField(
            controller: _toDateController,
            decoration: decoration('dd/mm/aaaa'),
            readOnly: true,
            onTap: () => _pickDate(context, _toDateController),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 140,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'Entrada', child: Text('Entrada')),
                  DropdownMenuItem(value: 'Saída', child: Text('Saída')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'Entrada'),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 36,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2ECC40),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () {},
            child: const Text('Gerar Relatório'),
          ),
        ),
      ],
    );
  }

  Widget _tableArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: const [
                _HeaderCell('Data'),
                _HeaderCell('Tipo'),
                _HeaderCell('Descrição', flex: 2),
                _HeaderCell('Valor Entrada'),
                _HeaderCell('Valor Saída'),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: const [
                _BodyCell('--'),
                _BodyCell('--'),
                _BodyCell('--', flex: 2),
                _BodyCell('R\$ --'),
                _BodyCell('R\$ --'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsRow(BuildContext context) {
    Widget btn(String text, {Color? color, Color? textColor}) => SizedBox(
          height: 32,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: color ?? Colors.white,
              foregroundColor: textColor ?? Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.symmetric(horizontal: 18),
            ),
            onPressed: () {},
            child: Text(text),
          ),
        );

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            minimumSize: const Size(120, 36),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            side: const BorderSide(color: Color(0xFF2ECC40), width: 1),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          child: const Text('Voltar'),
        ),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2ECC40),
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(140, 36),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          child: const Text('Exportar'),
        ),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2ECC40),
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(140, 36),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          child: const Text('Imprimir'),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, TextEditingController controller) async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (result != null) {
      controller.text = _formatDate(result);
      setState(() {});
    }
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd/$mm/$yy';
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {this.flex = 1});

  final String text;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  const _BodyCell(this.text, {this.flex = 1});

  final String text;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
