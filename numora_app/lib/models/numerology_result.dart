import 'package:json_annotation/json_annotation.dart';

part 'numerology_result.g.dart';

@JsonSerializable()
class NumerologyResult {
  final int lifePathNumber;
  final int soulNumber;
  final int destinyNumber;
  final int personalityNumber;
  final String aiInterpretation;
  final DateTime birthDate;
  final DateTime createdAt;

  const NumerologyResult({
    required this.lifePathNumber,
    required this.soulNumber,
    required this.destinyNumber,
    required this.personalityNumber,
    required this.aiInterpretation,
    required this.birthDate,
    required this.createdAt,
  });

  factory NumerologyResult.fromJson(Map<String, dynamic> json) =>
      _$NumerologyResultFromJson(json);

  Map<String, dynamic> toJson() => _$NumerologyResultToJson(this);

  NumerologyResult copyWith({
    int? lifePathNumber,
    int? soulNumber,
    int? destinyNumber,
    int? personalityNumber,
    String? aiInterpretation,
    DateTime? birthDate,
    DateTime? createdAt,
  }) {
    return NumerologyResult(
      lifePathNumber: lifePathNumber ?? this.lifePathNumber,
      soulNumber: soulNumber ?? this.soulNumber,
      destinyNumber: destinyNumber ?? this.destinyNumber,
      personalityNumber: personalityNumber ?? this.personalityNumber,
      aiInterpretation: aiInterpretation ?? this.aiInterpretation,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@JsonSerializable()
class UserProfile {
  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;
  final List<String> savedResults;
  final DateTime createdAt;
  final DateTime lastActive;

  const UserProfile({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    required this.savedResults,
    required this.createdAt,
    required this.lastActive,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
