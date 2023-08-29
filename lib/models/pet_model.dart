// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PetModel {
  final String? id;
  final String petName;
  final String petType;
  final String petBreed;
  final int petAge;
  final int petWeight;
  final bool petVaccinated;
  final bool petNeutered;
  final bool petMicrochip;
  final DateTime petBirthDate;
  final DateTime petLastCheckup;
  final DateTime petLastGrooming;
  PetModel({
    this.id,
    required this.petName,
    required this.petType,
    required this.petBreed,
    required this.petAge,
    required this.petWeight,
    required this.petVaccinated,
    required this.petNeutered,
    required this.petMicrochip,
    required this.petBirthDate,
    required this.petLastCheckup,
    required this.petLastGrooming,
  });

  PetModel copyWith({
    String? id,
    String? petName,
    String? petType,
    String? petBreed,
    int? petAge,
    int? petWeight,
    bool? petVaccinated,
    bool? petNeutered,
    bool? petMicrochip,
    DateTime? petBirthDate,
    DateTime? petLastCheckup,
    DateTime? petLastGrooming,
  }) {
    return PetModel(
      id: id ?? this.id,
      petName: petName ?? this.petName,
      petType: petType ?? this.petType,
      petBreed: petBreed ?? this.petBreed,
      petAge: petAge ?? this.petAge,
      petWeight: petWeight ?? this.petWeight,
      petVaccinated: petVaccinated ?? this.petVaccinated,
      petNeutered: petNeutered ?? this.petNeutered,
      petMicrochip: petMicrochip ?? this.petMicrochip,
      petBirthDate: petBirthDate ?? this.petBirthDate,
      petLastCheckup: petLastCheckup ?? this.petLastCheckup,
      petLastGrooming: petLastGrooming ?? this.petLastGrooming,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'petName': petName,
      'petType': petType,
      'petBreed': petBreed,
      'petAge': petAge,
      'petWeight': petWeight,
      'petVaccinated': petVaccinated,
      'petNeutered': petNeutered,
      'petMicrochip': petMicrochip,
      'petBirthDate': petBirthDate.millisecondsSinceEpoch,
      'petLastCheckup': petLastCheckup.millisecondsSinceEpoch,
      'petLastGrooming': petLastGrooming.millisecondsSinceEpoch,
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'] != null ? map['id'] as String : null,
      petName: map['petName'] as String,
      petType: map['petType'] as String,
      petBreed: map['petBreed'] as String,
      petAge: map['petAge'] as int,
      petWeight: map['petWeight'] as int,
      petVaccinated: map['petVaccinated'] as bool,
      petNeutered: map['petNeutered'] as bool,
      petMicrochip: map['petMicrochip'] as bool,
      petBirthDate:
          DateTime.fromMillisecondsSinceEpoch(map['petBirthDate'] as int),
      petLastCheckup:
          DateTime.fromMillisecondsSinceEpoch(map['petLastCheckup'] as int),
      petLastGrooming:
          DateTime.fromMillisecondsSinceEpoch(map['petLastGrooming'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PetModel.fromJson(String source) =>
      PetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PetModel(id: $id, petName: $petName, petType: $petType, petBreed: $petBreed, petAge: $petAge, petWeight: $petWeight, petVaccinated: $petVaccinated, petNeutered: $petNeutered, petMicrochip: $petMicrochip, petBirthDate: $petBirthDate, petLastCheckup: $petLastCheckup, petLastGrooming: $petLastGrooming)';
  }

  @override
  bool operator ==(covariant PetModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.petName == petName &&
        other.petType == petType &&
        other.petBreed == petBreed &&
        other.petAge == petAge &&
        other.petWeight == petWeight &&
        other.petVaccinated == petVaccinated &&
        other.petNeutered == petNeutered &&
        other.petMicrochip == petMicrochip &&
        other.petBirthDate == petBirthDate &&
        other.petLastCheckup == petLastCheckup &&
        other.petLastGrooming == petLastGrooming;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        petName.hashCode ^
        petType.hashCode ^
        petBreed.hashCode ^
        petAge.hashCode ^
        petWeight.hashCode ^
        petVaccinated.hashCode ^
        petNeutered.hashCode ^
        petMicrochip.hashCode ^
        petBirthDate.hashCode ^
        petLastCheckup.hashCode ^
        petLastGrooming.hashCode;
  }
}
