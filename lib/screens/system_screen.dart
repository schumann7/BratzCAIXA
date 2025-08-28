import 'package:flutter/material.dart';
import 'package:bratzcaixa/components/header.dart';

class SystemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [const HeaderBar(), Expanded(child: SistemPageBody())],
        ),
      ),
    );
  }
}

class SistemPageBody extends StatelessWidget {
  final TextEditingController searchControllerName = TextEditingController();
  final TextEditingController searchControllerCode = TextEditingController();

  List<Map<String, dynamic>> responseItems = [
    {
      "item": "banana",
      "code": "123",
      "description": "TextoTextoTextoTexto",
      "value": "12,99",
      "quantity": "3",
    },
    {
      "item": "maça",
      "code": "456",
      "description": "TextoTextoTextoTexto",
      "value": "5,49",
      "quantity": "1",
    },
  ];

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _titleBar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [_productSearchName(), _productValue()],
                ),
                _productSearchCode(),
              ],
            ),
            SizedBox(width: 50),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
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
                              color: const Color(0xFF2E7DFF),
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
                          // Cabeçalhos de coluna
                          DataTable(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // Removido o arredondamento aqui para evitar conflito visual
                            ),
                            columns: [
                              DataColumn(label: Text('Item')),
                              DataColumn(label: Text('Código')),
                              DataColumn(label: Text('Descrição')),
                              DataColumn(label: Text('Valor')),
                              DataColumn(label: Text('Total')),
                            ],
                            rows:
                                responseItems
                                    .map(
                                      (item) => DataRow(
                                        cells: [
                                          DataCell(Text(item['item'])),
                                          DataCell(Text(item['code'])),
                                          DataCell(Text(item['description'])),
                                          DataCell(Text(item['value'])),
                                          DataCell(Text('total')),
                                        ],
                                      ),
                                    )
                                    .toList(),
                          ),
                          const Divider(height: 1, thickness: 1),
                          // Espaço de lista (placeholder)
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFFCFEF2),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Nenhum produto carregado',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  _subtotal(),
                  Row(children: [_receipt(), SizedBox(width: 20), _change()]),
                ],
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

  Widget _productSearchName() {
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

      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produto',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 1.0,
            ),
          ),
          TextField(
            controller: searchControllerName,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              hintText: 'Buscar por nome',
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
          ),
        ],
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
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Código de Barras',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 1.0,
            ),
          ),
          TextField(
            controller: searchControllerCode,
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
          ),
        ],
      ),
    );
  }

  Widget _productValue() {
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
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 20, left: 95),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Valor Unitário',
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
    );
  }

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
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(top: 20, left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subtotal',
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
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(top: 20, left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(top: 20, left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
}
