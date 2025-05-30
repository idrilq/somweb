import 'package:flutter/material.dart';
import 'dart:async';

class ShiftAutoProvider extends ChangeNotifier {
  bool enabled = false;
  TimeOfDay openTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay closeTime = const TimeOfDay(hour: 0, minute: 0);

  Timer? _timer;
  VoidCallback? onOpenShift;
  VoidCallback? onCloseShift;

  void setEnabled(bool val) {
    enabled = val;
    notifyListeners();
  }

  void setOpenTime(TimeOfDay time) {
    openTime = time;
    notifyListeners();
  }

  void setCloseTime(TimeOfDay time) {
    closeTime = time;
    notifyListeners();
  }

  void setCallbacks({VoidCallback? onOpen, VoidCallback? onClose}) {
    onOpenShift = onOpen;
    onCloseShift = onClose;
    restartScheduler();
  }

  void restartScheduler() {
    _timer?.cancel();
    if (enabled && (onOpenShift != null || onCloseShift != null)) {
      _timer = Timer.periodic(const Duration(seconds: 30), (_) => _checkAndRun());
    }
  }

  void _checkAndRun() {
    if (!enabled) return;
    final now = TimeOfDay.fromDateTime(DateTime.now());
    if (now.hour == openTime.hour && now.minute == openTime.minute) {
      onOpenShift?.call();
    }
    if (now.hour == closeTime.hour && now.minute == closeTime.minute) {
      onCloseShift?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
