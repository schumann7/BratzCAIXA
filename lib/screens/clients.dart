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
                ],
              ),
            ),
            Container(
              width: 600,
              decoration: BoxDecoration(
                color: Color(0xFF36CDEB),
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Column(
              children: [
                Text(
                    "Lista de Clientes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
