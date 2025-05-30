class RegistratorConnectionParams {
  final String ip;
  final int port;
  final bool isConnected;

  RegistratorConnectionParams({
    required this.ip,
    required this.port,
    this.isConnected = false,
  });

  RegistratorConnectionParams copyWith({bool? isConnected}) {
    return RegistratorConnectionParams(
      ip: ip,
      port: port,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
