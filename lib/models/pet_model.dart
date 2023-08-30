// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PetModel {
  final String? id;
  final String ownerid;
  final String avatar;
  final String name;
  final String type;
  final String breed;
  final int age;
  final int weight;
  final bool vaccinated;
  final bool neutered;
  final bool microchip;
  // final DateTime petBirthDate;
  // final DateTime petLastCheckup;
  // final DateTime petLastGrooming;
  PetModel({
    this.id,
    required this.ownerid,
    required this.avatar,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.weight,
    required this.vaccinated,
    required this.neutered,
    required this.microchip,
  });

  PetModel copyWith({
    String? id,
    String? ownerid,
    String? avatar,
    String? name,
    String? type,
    String? breed,
    int? age,
    int? weight,
    bool? vaccinated,
    bool? neutered,
    bool? microchip,
  }) {
    return PetModel(
      id: id ?? this.id,
      ownerid: ownerid ?? this.ownerid,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      vaccinated: vaccinated ?? this.vaccinated,
      neutered: neutered ?? this.neutered,
      microchip: microchip ?? this.microchip,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerid': ownerid,
      'avatar': avatar,
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'weight': weight,
      'vaccinated': vaccinated,
      'neutered': neutered,
      'microchip': microchip,
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'] != null ? map['id'] as String : null,
      ownerid: map['ownerid'] as String,
      avatar: map['avatar'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      breed: map['breed'] as String,
      age: map['age'] as int,
      weight: map['weight'] as int,
      vaccinated: map['vaccinated'] as bool,
      neutered: map['neutered'] as bool,
      microchip: map['microchip'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PetModel.fromJson(String source) =>
      PetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PetModel(id: $id, ownerid: $ownerid, avatar: $avatar, name: $name, type: $type, breed: $breed, age: $age, weight: $weight, vaccinated: $vaccinated, neutered: $neutered, microchip: $microchip)';
  }

  @override
  bool operator ==(covariant PetModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ownerid == ownerid &&
        other.avatar == avatar &&
        other.name == name &&
        other.type == type &&
        other.breed == breed &&
        other.age == age &&
        other.weight == weight &&
        other.vaccinated == vaccinated &&
        other.neutered == neutered &&
        other.microchip == microchip;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerid.hashCode ^
        avatar.hashCode ^
        name.hashCode ^
        type.hashCode ^
        breed.hashCode ^
        age.hashCode ^
        weight.hashCode ^
        vaccinated.hashCode ^
        neutered.hashCode ^
        microchip.hashCode;
  }
}
