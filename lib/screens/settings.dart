import 'package:flutter/material.dart';
import 'package:bratz/components/header.dart';

const Color kPanelBg = Color(0xFFD9D9D9);
const Color kLabelColor = Colors.white;
const Color kGreenBtn = Color(0xFF2ED15F);

class SettingsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(),
            const Expanded(child: _SettingsBody()),
          ],
        ),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ShortcutsSection(),
                const SizedBox(height: 20),
                _PreferencesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: kLabelColor,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: kPanelBg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ShortcutsSection extends StatelessWidget {
  final List<_ShortcutField> left = const [
    _ShortcutField(label: 'Código Interno', hint: 'F2'),
    _ShortcutField(label: 'Excluir Item', hint: 'F3'),
    _ShortcutField(label: 'Inserir Quantidade', hint: 'F4'),
  ];
  final List<_ShortcutField> right = const [
    _ShortcutField(label: 'Nova Venda', hint: 'F5'),
    _ShortcutField(label: 'Gaveta', hint: 'F6'),
    _ShortcutField(label: 'Pesquisar Venda', hint: 'F7'),
  ];
  final List<_ShortcutField> farRight = const [
    _ShortcutField(label: 'Pesquisar Produto', hint: 'F8'),
    _ShortcutField(label: 'Alterar Venda', hint: 'F9'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Atalhos do Teclado',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _ShortcutColumn(fields: left)),
              const SizedBox(width: 24),
              Expanded(child: _ShortcutColumn(fields: right)),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _ShortcutColumn(fields: farRight),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGreenBtn,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 3,
                        ),
                        onPressed: () {},
                        child: const Text('+ Adicionar Atalho'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShortcutColumn extends StatelessWidget {
  const _ShortcutColumn({required this.fields});
  final List<_ShortcutField> fields;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields
          .map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LabeledField(label: f.label, hint: f.hint),
            ),
          )
          .toList(),
    );
  }
}

class _ShortcutField {
  final String label;
  final String hint;
  const _ShortcutField({required this.label, required this.hint});
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.hint});
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 28,
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PreferencesSection extends StatelessWidget {
  final List<String> temas = const ['Escuro', 'Claro'];
  final List<String> fontes = const ['Pequena', 'Média', 'Grande'];
  final List<String> notificacoes = const ['Som', 'Vibração', 'Silêncio'];

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Preferências da Interface',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PreferenceRow(label: 'Tema da Interface', values: temas, initial: 'Escuro'),
          const SizedBox(height: 10),
          _PreferenceRow(label: 'Tamanho da Fonte', values: fontes, initial: 'Média'),
          const SizedBox(height: 10),
          _PreferenceRow(label: 'Notificação', values: notificacoes, initial: 'Som'),
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatefulWidget {
  const _PreferenceRow({required this.label, required this.values, required this.initial});
  final String label;
  final List<String> values;
  final String initial;

  @override
  State<_PreferenceRow> createState() => _PreferenceRowState();
}

class _PreferenceRowState extends State<_PreferenceRow> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 160,
          child: Text(
            widget.label,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 150,
          height: 28,
          child: DropdownButtonFormField<String>(
            value: selected,
            items: widget.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => selected = v ?? widget.initial),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}