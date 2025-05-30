import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/terminals_provider.dart';

class TerminalEditDialog extends StatefulWidget {
  final String? terminal;

  const TerminalEditDialog({this.terminal, super.key});

  @override
  State<TerminalEditDialog> createState() => _TerminalEditDialogState();
}

class _TerminalEditDialogState extends State<TerminalEditDialog> {
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
      // Здесь можно загрузить настройки по terminal, если они где-то хранятся
      _nameController.text = widget.terminal!;
      _numberController.text = '0300170078226682';
      _tokenController.text = '396243';
      _commentController.text = widget.terminal!;
      _organization = '662500223980, ИП Дрыгин Константин Дмитриевич';
      _isBlocked = false;
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
    return AlertDialog(
      title: Text(isEdit ? 'Редактирование терминала' : 'Добавить терминал'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(
                labelText: 'Номер',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Токен',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Комментарий',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _organization,
              items: const [
                DropdownMenuItem(
                  value: '662500223980, ИП Дрыгин Константин Дмитриевич',
                  child: Text('662500223980, ИП Дрыгин Константин Дмитриевич'),
                ),
                // Добавьте другие организации, если нужно
              ],
              onChanged: (val) => setState(() => _organization = val!),
              decoration: const InputDecoration(
                labelText: 'Организация',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Терминал заблокирован'),
              value: _isBlocked,
              onChanged: (val) => setState(() => _isBlocked = val ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Назад'),
        ),
        ElevatedButton(
          onPressed: () {
            final provider = Provider.of<TerminalsProvider>(context, listen: false);
            if (isEdit) {
              provider.updateTerminal(widget.terminal!, _nameController.text);
            } else {
              provider.addTerminal(_nameController.text);
            }
            Navigator.pop(context);
          },
          child: Text(isEdit ? 'Обновить' : 'Добавить'),
        ),
      ],
    );
  }
}
