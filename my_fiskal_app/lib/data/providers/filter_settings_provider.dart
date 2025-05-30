import 'package:flutter/foundation.dart';
import '../models/filter_settings.dart';

class FilterSettingsProvider extends ChangeNotifier {
  FilterSettings _settings = const FilterSettings();

  FilterSettings get settings => _settings;

  void updateSettings(FilterSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }
}
