import 'package:flutter/material.dart';

class ClientSearchHeader extends StatelessWidget {
  final String title;
  final TextEditingController searchController;
  final ValueSetter<String> onSearch;

  const ClientSearchHeader({
    super.key,
    required this.title,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
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
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Buscar por nome, CPF ou telefone",
                  filled: true,
                  fillColor: Color(0xFFFCFEF2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: onSearch,
              ),
            ),
            IconButton(
              onPressed: () => onSearch(searchController.text),
              icon: const Icon(Icons.search, color: Colors.white, size: 30),
            ),
          ],
        ),
      ],
    );
  }
}