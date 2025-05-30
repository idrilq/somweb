import 'package:flutter/foundation.dart';

class TerminalsProvider extends ChangeNotifier {
  final List<String> _terminals = []; // Список теперь пустой

  List<String> get terminals => _terminals;

  void addTerminal(String terminal) {
    if (!_terminals.contains(terminal)) {
      _terminals.add(terminal);
      notifyListeners();
    }
  }

  void updateTerminal(String oldName, String newName) {
    final index = _terminals.indexOf(oldName);
    if (index != -1 && !_terminals.contains(newName)) {
      _terminals[index] = newName;
      notifyListeners();
    }
  }

  void deleteTerminal(String terminal) {
    if (_terminals.remove(terminal)) {
      notifyListeners();
    }
  }

  // Можно добавить метод для массовой загрузки терминалов из API/БД:
  void setTerminals(List<String> terminals) {
    _terminals
      ..clear()
      ..addAll(terminals);
    notifyListeners();
  }
}
