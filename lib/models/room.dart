enum RoomStatus {
  available,
  occupied,
  maintenance,
}

class Room {
  final int id;
  final String number;
  final String roomType;
  final RoomStatus status;
  final DateTime? lastCleaned;
  final String? notes;
  final DateTime createdAt;

  Room({
    required this.id,
    required this.number,
    required this.roomType,
    required this.status,
    this.lastCleaned,
    this.notes,
    required this.createdAt,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] ?? 0,
      number: map['numero'] ?? '',
      roomType: map['tipo'] ?? 'Cuarto',
      status: _statusFromInt(map['disponible'] ?? 1),
      lastCleaned: map['last_cleaned'] != null 
          ? DateTime.parse(map['last_cleaned'])
          : null,
      notes: map['observaciones'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': number,
      'tipo': roomType,
      'disponible': _statusToInt(status),
      'last_cleaned': lastCleaned?.toIso8601String(),
      'observaciones': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static RoomStatus _statusFromInt(int value) {
    switch (value) {
      case 1:
        return RoomStatus.available;
      case 0:
        return RoomStatus.occupied;
      case 2:
        return RoomStatus.maintenance;
      default:
        return RoomStatus.available;
    }
  }

  static int _statusToInt(RoomStatus status) {
    switch (status) {
      case RoomStatus.available:
        return 1;
      case RoomStatus.occupied:
        return 0;
      case RoomStatus.maintenance:
        return 2;
    }
  }

  Room copyWith({
    int? id,
    String? number,
    String? roomType,
    RoomStatus? status,
    DateTime? lastCleaned,
    String? notes,
    DateTime? createdAt,
  }) {
    return Room(
      id: id ?? this.id,
      number: number ?? this.number,
      roomType: roomType ?? this.roomType,
      status: status ?? this.status,
      lastCleaned: lastCleaned ?? this.lastCleaned,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RoomType {
  final int id;
  final String name;
  final String description;
  final double hourlyRate;
  final double dailyRate;
  final DateTime createdAt;

  RoomType({
    required this.id,
    required this.name,
    required this.description,
    required this.hourlyRate,
    required this.dailyRate,
    required this.createdAt,
  });

  factory RoomType.fromMap(Map<String, dynamic> map) {
    return RoomType(
      id: map['id'] ?? 0,
      name: map['nombre'] ?? '',
      description: map['descripcion'] ?? '',
      hourlyRate: (map['por_hora'] ?? 0.0).toDouble(),
      dailyRate: (map['por_dia'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': name,
      'descripcion': description,
      'por_hora': hourlyRate,
      'por_dia': dailyRate,
      'created_at': createdAt.toIso8601String(),
    };
  }
}