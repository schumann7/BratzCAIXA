import 'package:flutter/material.dart';
import 'package:bratz/components/brand.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Brand(text: 'Bratz', color: Color(0xFFD8B247)),
            ],
          ),
          const Brand(text: '4BEFORE', color: Color(0xFF5B6770)),
        ],
      ),
    );
  }
}