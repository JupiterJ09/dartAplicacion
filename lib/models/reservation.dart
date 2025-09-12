enum ReservationStatus {
  active,
  completed,
  cancelled,
}

class Reservation {
  final int id;
  final int roomId;
  final String roomNumber;
  final String roomType;
  final double priceUsed;
  final int totalHours;
  final double totalIncome;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime requestDate;
  final ReservationStatus status;
  final String? notes;

  Reservation({
    required this.id,
    required this.roomId,
    required this.roomNumber,
    required this.roomType,
    required this.priceUsed,
    required this.totalHours,
    required this.totalIncome,
    required this.startDate,
    this.endDate,
    required this.requestDate,
    required this.status,
    this.notes,
  });

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] ?? 0,
      roomId: map['cuarto_id'] ?? 0,
      roomNumber: map['cuarto_numero'] ?? '',
      roomType: map['tipo_habitacion'] ?? '',
      priceUsed: (map['precio_usado'] ?? 0.0).toDouble(),
      totalHours: map['horas_totales'] ?? 0,
      totalIncome: (map['ingreso_total'] ?? 0.0).toDouble(),
      startDate: DateTime.parse(map['fecha_inicio'] ?? DateTime.now().toIso8601String()),
      endDate: map['fecha_fin'] != null ? DateTime.parse(map['fecha_fin']) : null,
      requestDate: DateTime.parse(map['fecha_solicitud'] ?? DateTime.now().toIso8601String()),
      status: _statusFromString(map['estado'] ?? 'activa'),
      notes: map['observaciones'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cuarto_id': roomId,
      'precio_usado': priceUsed,
      'horas_totales': totalHours,
      'ingreso_total': totalIncome,
      'fecha_inicio': startDate.toIso8601String(),
      'fecha_fin': endDate?.toIso8601String(),
      'fecha_solicitud': requestDate.toIso8601String(),
      'estado': _statusToString(status),
      'observaciones': notes,
    };
  }

  static ReservationStatus _statusFromString(String value) {
    switch (value) {
      case 'activa':
        return ReservationStatus.active;
      case 'finalizada':
        return ReservationStatus.completed;
      case 'cancelada':
        return ReservationStatus.cancelled;
      default:
        return ReservationStatus.active;
    }
  }

  static String _statusToString(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.active:
        return 'activa';
      case ReservationStatus.completed:
        return 'finalizada';
      case ReservationStatus.cancelled:
        return 'cancelada';
    }
  }

  Duration get duration => totalHours > 0 
      ? Duration(hours: totalHours) 
      : endDate?.difference(startDate) ?? Duration.zero;

  bool get isActive => status == ReservationStatus.active;
  bool get isCompleted => status == ReservationStatus.completed;
  bool get isCancelled => status == ReservationStatus.cancelled;
}