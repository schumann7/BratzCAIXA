import 'package:flutter/material.dart';

class ProductSearchHeader extends StatelessWidget {
  final String title;
  final TextEditingController searchController;
  final ValueSetter<String> onSearch;

  const ProductSearchHeader({
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
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  hintText: 'Buscar por nome ou marca',
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
                onSubmitted: onSearch,
              ),
            ),
            IconButton(
              onPressed: () => onSearch(searchController.text),
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }
}