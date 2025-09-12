class Guest {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? identification;
  final DateTime createdAt;

  Guest({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.identification,
    required this.createdAt,
  });

  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(
      id: map['id'] ?? 0,
      name: map['nombre'] ?? '',
      phone: map['telefono'],
      email: map['email'],
      identification: map['identificacion'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': name,
      'telefono': phone,
      'email': email,
      'identificacion': identification,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Guest copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? identification,
    DateTime? createdAt,
  }) {
    return Guest(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      identification: identification ?? this.identification,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}