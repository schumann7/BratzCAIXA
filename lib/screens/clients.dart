import 'package:bratz/components/header.dart';
import 'package:flutter/material.dart';

class ClientsScreen extends StatelessWidget {
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

class ClientsPageBody extends StatelessWidget {
  final TextEditingController _clientSearchController = TextEditingController();

  List<Map<String, dynamic>> responseItems = [
    {"name": "John Doe", "cpf": "000.000.000-00", "phone": "(00) 0000-0000"},
    {"name": "John Doe", "cpf": "000.000.000-00", "phone": "(00) 0000-0000"},
    {"name": "John Doe", "cpf": "000.000.000-00", "phone": "(00) 0000-0000"},
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
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
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
                          decoration: InputDecoration(
                            hintText: "Buscar por nome, CPF ou telefone",
                            filled: true,
                            fillColor: Color(0xFFFCFEF2),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search, color: Colors.white, size: 30),
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox()),

                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.resolveWith<OutlinedBorder?>((
                                states,
                              ) {
                                return BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                );
                              }),
                          fixedSize: WidgetStateProperty.resolveWith<Size?>((
                            states,
                          ) {
                            return Size(200, 75);
                          }),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>((
                                Set<WidgetState> states,
                              ) {
                                return Color(0xFF36CDEB);
                              }),
                        ),
                        child: Text(
                          "+ Novo Cliente",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 50,),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.resolveWith<OutlinedBorder?>((
                                states,
                              ) {
                                return BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                );
                              }),
                          fixedSize: WidgetStateProperty.resolveWith<Size?>((
                            states,
                          ) {
                            return Size(200, 75);
                          }),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>((
                                Set<WidgetState> states,
                              ) {
                                return Color(0xFF36CDEB);
                              }),
                        ),
                        child: Text(
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
              decoration: BoxDecoration(
                color: Color(0xFF36CDEB),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Lista de Clientes",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ),

                  Expanded(
                    child: SizedBox(
                      width: 800,
                      child: DataTable(
                        decoration: BoxDecoration(
                          color: Color(0xFFFCFEF2),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        columns: [
                          DataColumn(label: Text('Nome')),
                          DataColumn(label: Text('CPF')),
                          DataColumn(label: Text('Telefone')),
                          DataColumn(label: Text('Ações')),
                        ],
                        rows:
                            responseItems
                                .map(
                                  (item) => DataRow(
                                    cells: [
                                      DataCell(Text(item['name'])),
                                      DataCell(Text(item['cpf'].toString())),
                                      DataCell(Text(item['phone'])),
                                      DataCell(
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text("Ação"),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
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
