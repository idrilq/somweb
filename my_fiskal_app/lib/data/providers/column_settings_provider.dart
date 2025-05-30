import 'package:flutter/foundation.dart';
import '../models/column_settings.dart';

class ColumnSettingsProvider extends ChangeNotifier {
  ColumnSettings _settings = const ColumnSettings();

  ColumnSettings get settings => _settings;

  void updateSettings(ColumnSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }
}
