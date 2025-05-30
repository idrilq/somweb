import 'package:flutter/material.dart';
import '../models/registrator.dart';

class RegistratorsProvider extends ChangeNotifier {
  final List<Registrator> _registrators = [];
  
  List<Registrator> get registrators => _registrators;

  void addRegistrator(Registrator registrator) {
    _registrators.add(registrator);
    notifyListeners();
  }

  void updateRegistrator(int index, Registrator registrator) {
    _registrators[index] = registrator;
    notifyListeners();
  }
}
