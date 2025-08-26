import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bool showHome = Navigator.canPop(context);

    return Container(
      height: 80,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 24, right: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Espaço fixo para o ícone Home, não desloca o alinhamento
              SizedBox(
                width: 28,
                child: showHome
                    ? IconButton(
                        tooltip: 'Início',
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        splashRadius: 18,
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        icon: const Icon(
                          Icons.home_outlined,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 16),
              Image.asset('assets/logo-bratz.png', height: 50),
            ],
          ),
          Image.asset('assets/logo-4before.png', height: 100,)
        ],
      ),
    );
  }
}