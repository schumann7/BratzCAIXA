import 'package:flutter/material.dart';
import 'package:bratz/components/header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(),
            const Expanded(child: _DashboardBody()),
          ],
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2B2B2B),
            Color(0xFF1F1F1F),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Bloco grande: Sistema
                    Expanded(
                      flex: 3,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _DashboardTile(
                          color: const Color(0xFF2E7DFF),
                          icon: Icons.desktop_windows,
                          label: 'Sistema',
                          onTap: () {},
                          big: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Grade à direita 2x2
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: _DashboardTile(
                                    color: const Color(0xE6E6B23A), // amarelo mostarda
                                    icon: Icons.shopping_cart,
                                    label: 'Produtos',
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _DashboardTile(
                                    color: const Color(0xFF2ECC40), // verde
                                    icon: Icons.attach_money,
                                    label: 'Financeiro',
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: _DashboardTile(
                                    color: const Color(0xFF29C7F0), // ciano
                                    icon: Icons.group,
                                    label: 'Clientes',
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _DashboardTile(
                                    color: const Color(0xFFBEBEBE), // cinza
                                    icon: Icons.settings,
                                    label: 'Configurações',
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  const _DashboardTile({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
    this.big = false,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: big ? 72 : 48,
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}