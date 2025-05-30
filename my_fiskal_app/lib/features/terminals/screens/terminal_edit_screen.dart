import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/terminals_provider.dart';

class TerminalEditScreen extends StatefulWidget {
  final String? terminal;
  const TerminalEditScreen({super.key, this.terminal});

  @override
  State<TerminalEditScreen> createState() => _TerminalEditScreenState();
}

class _TerminalEditScreenState extends State<TerminalEditScreen> {
  final _numberController = TextEditingController();
  final _nameController = TextEditingController();
  final _tokenController = TextEditingController();
  final _commentController = TextEditingController();
  String _organization = '662500223980, ИП Дрыгин Константин Дмитриевич';
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    if (widget.terminal != null) {
      _nameController.text = widget.terminal!;
      // Для демонстрации заполним остальные поля
      _numberController.text = '0300170078226682';
      _tokenController.text = '396243';
      _commentController.text = widget.terminal!;
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    _tokenController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.terminal != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Редактирование терминала' : 'Добавить терминал')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Номер', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: _numberController),
              const SizedBox(height: 16),
              
              const Text('Имя', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: _nameController),
              const SizedBox(height: 16),
              
              const Text('Токен', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: _tokenController),
              const SizedBox(height: 16),
              
              const Text('Комментарий', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: _commentController),
              const SizedBox(height: 16),
              
              const Text('Организация', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _organization,
                items: [_organization]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _organization = val!),
              ),
              const SizedBox(height: 16),
              
              CheckboxListTile(
                title: const Text('Терминал заблокирован'),
                value: _isBlocked,
                onChanged: (val) => setState(() => _isBlocked = val ?? false),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _saveTerminal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(isEdit ? 'Обновить' : 'Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTerminal() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final provider = Provider.of<TerminalsProvider>(context, listen: false);
    if (widget.terminal == null) {
      provider.addTerminal(name);
    } else {
      provider.updateTerminal(widget.terminal!, name);
    }
    Navigator.of(context).pop();
  }
}
