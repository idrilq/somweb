import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';

class RegistratorConnectProvider extends ChangeNotifier {
  String? ip;
  int? port;
  bool isConnected = false;

  final List<String> _logs = [];
  List<String> get logs => List.unmodifiable(_logs);

  void addLog(String message) {
    final now = DateTime.now();
    _logs.insert(
      0,
      '[${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}] $message',
    );
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  Future<bool> connect(String newIp, int newPort) async {
    ip = newIp;
    port = newPort;
    isConnected = await checkDeviceOnline();
    addLog(isConnected
        ? 'ККТ подключена: $ip:$port'
        : 'Ошибка подключения к ККТ: $ip:$port');
    notifyListeners();
    return isConnected;
  }

  Future<bool> checkDeviceOnline() async {
    if (ip == null || port == null) return false;
    try {
      final socket = await Socket.connect(ip, port!, timeout: const Duration(seconds: 3));
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> sendCommand(
    String commandName,
    List<int> packet,
    List<int> expectedResponse,
  ) async {
    if (ip == null || port == null) {
      addLog('ККТ не подключена');
      return 'ККТ не подключена';
    }
    
    Socket? socket;
    try {
      addLog('Отправка [$commandName]: ${_bytesToHex(packet)}');
      socket = await Socket.connect(ip, port!, timeout: const Duration(seconds: 10));
      socket.add(packet);
      await socket.flush();

      final response = await socket.fold<List<int>>(
        <int>[],
        (bytes, data) => bytes..addAll(data),
      ).timeout(const Duration(seconds: 10));

      addLog('Ответ: ${_bytesToHex(response)}');
      
      final result = _parseKktResponse(commandName, response, expectedResponse);
      addLog(result);
      return result;

    } on TimeoutException {
      const error = 'Таймаут ожидания ответа от ККТ';
      addLog(error);
      return error;
    } on SocketException catch (e) {
      final error = 'Сетевая ошибка: ${e.message}';
      addLog(error);
      return error;
    } catch (e) {
      final error = 'Критическая ошибка: ${e.toString()}';
      addLog(error);
      return error;
    } finally {
      await socket?.close();
      socket?.destroy();
    }
  }

  String _parseKktResponse(String commandName, List<int> response, List<int> expected) {
    if (response.length != expected.length) {
      return 'Ошибка: неверная длина ответа (ожидалось ${expected.length}, получено ${response.length})';
    }

    for (int i = 0; i < expected.length; i++) {
      if (response[i] != expected[i]) {
        return 'Ошибка: неверный байт в позиции $i (ожидалось 0x${expected[i].toRadixString(16)}, получено 0x${response[i].toRadixString(16)})';
      }
    }

    switch (commandName) {
      case 'Открыть смену':
        return 'Смена успешно открыта!';
      case 'Закрыть смену':
        return 'Смена успешно закрыта!';
      case 'Снять X-отчет':
        return 'X-отчет успешно снят!';
      default:
        return 'Команда выполнена успешно!';
    }
  }

  String _bytesToHex(List<int> bytes) => bytes
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join(' ')
      .toUpperCase();
}
