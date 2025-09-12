class Expense {
  final int id;
  final double amount;
  final String description;
  final DateTime date;
  final String? category;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    this.category,
    required this.createdAt,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? 0,
      amount: (map['monto'] ?? 0.0).toDouble(),
      description: map['descripcion'] ?? '',
      date: DateTime.parse(map['fecha'] ?? DateTime.now().toIso8601String()),
      category: map['categoria'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monto': amount,
      'descripcion': description,
      'fecha': date.toIso8601String().split('T')[0], // Solo fecha
      'categoria': category,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  Expense copyWith({
    int? id,
    double? amount,
    String? description,
    DateTime? date,
    String? category,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}