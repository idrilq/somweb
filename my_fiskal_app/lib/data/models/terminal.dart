class Terminal {
  final String id;
  final String name;

  const Terminal({required this.id, required this.name});

  Terminal copyWith({String? id, String? name}) {
    return Terminal(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
