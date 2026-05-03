import 'package:equatable/equatable.dart';

/// A robust wrapper providing strongly-typed Enum-like behaviors
/// while preserving raw string payloads from APIs (e.g., 'pack', 'bottle').
class MedicineUnit extends Equatable {
  final String value;

  const MedicineUnit._(this.value);

  static const MedicineUnit box = MedicineUnit._('box');
  static const MedicineUnit strip = MedicineUnit._('strip');

  bool get isBox => value.toLowerCase() == 'box';
  bool get isStrip => value.toLowerCase() == 'strip';

  bool get isKnown => isBox || isStrip;

  /// Secure semantic parsing intercepting unknown API injections
  factory MedicineUnit.fromJson(String? json) {
    if (json == null || json.trim().isEmpty) return box; // Default fallback

    final lower = json.trim().toLowerCase();
    if (lower == 'box') return box;
    if (lower == 'strip') return strip;

    return MedicineUnit._(json.trim()); // Preserves raw original value
  }

  String toJson() => value;

  @override
  List<Object?> get props => [value];
}
