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
  final DateTime birthday;
  final DateTime lastvetvisit;
  final DateTime lastgrooming;
  final DateTime lastwalk;
  final DateTime lastbath;
  final DateTime lastmedication;
  final DateTime lastplaytime;
  final DateTime lastfeeding;

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
    required this.birthday,
    required this.lastvetvisit,
    required this.lastgrooming,
    required this.lastwalk,
    required this.lastbath,
    required this.lastmedication,
    required this.lastplaytime,
    required this.lastfeeding,
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
    DateTime? birthday,
    DateTime? lastvetvisit,
    DateTime? lastgrooming,
    DateTime? lastwalk,
    DateTime? lastbath,
    DateTime? lastmedication,
    DateTime? lastplaytime,
    DateTime? lastfeeding,
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
      birthday: birthday ?? this.birthday,
      lastvetvisit: lastvetvisit ?? this.lastvetvisit,
      lastgrooming: lastgrooming ?? this.lastgrooming,
      lastwalk: lastwalk ?? this.lastwalk,
      lastbath: lastbath ?? this.lastbath,
      lastmedication: lastmedication ?? this.lastmedication,
      lastplaytime: lastplaytime ?? this.lastplaytime,
      lastfeeding: lastfeeding ?? this.lastfeeding,
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
      'birthday': birthday.millisecondsSinceEpoch,
      'lastvetvisit': lastvetvisit.millisecondsSinceEpoch,
      'lastgrooming': lastgrooming.millisecondsSinceEpoch,
      'lastwalk': lastwalk.millisecondsSinceEpoch,
      'lastbath': lastbath.millisecondsSinceEpoch,
      'lastmedication': lastmedication.millisecondsSinceEpoch,
      'lastplaytime': lastplaytime.millisecondsSinceEpoch,
      'lastfeeding': lastfeeding.millisecondsSinceEpoch,
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
      birthday: DateTime.fromMillisecondsSinceEpoch(map['birthday'] as int),
      lastvetvisit:
          DateTime.fromMillisecondsSinceEpoch(map['lastvetvisit'] as int),
      lastgrooming:
          DateTime.fromMillisecondsSinceEpoch(map['lastgrooming'] as int),
      lastwalk: DateTime.fromMillisecondsSinceEpoch(map['lastwalk'] as int),
      lastbath: DateTime.fromMillisecondsSinceEpoch(map['lastbath'] as int),
      lastmedication:
          DateTime.fromMillisecondsSinceEpoch(map['lastmedication'] as int),
      lastplaytime:
          DateTime.fromMillisecondsSinceEpoch(map['lastplaytime'] as int),
      lastfeeding:
          DateTime.fromMillisecondsSinceEpoch(map['lastfeeding'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PetModel.fromJson(String source) =>
      PetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PetModel(id: $id, ownerid: $ownerid, avatar: $avatar, name: $name, type: $type, breed: $breed, age: $age, weight: $weight, vaccinated: $vaccinated, neutered: $neutered, microchip: $microchip, birthday: $birthday, lastvetvisit: $lastvetvisit, lastgrooming: $lastgrooming, lastwalk: $lastwalk, lastbath: $lastbath, lastmedication: $lastmedication, lastplaytime: $lastplaytime, lastfeeding: $lastfeeding)';
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
        other.microchip == microchip &&
        other.birthday == birthday &&
        other.lastvetvisit == lastvetvisit &&
        other.lastgrooming == lastgrooming &&
        other.lastwalk == lastwalk &&
        other.lastbath == lastbath &&
        other.lastmedication == lastmedication &&
        other.lastplaytime == lastplaytime &&
        other.lastfeeding == lastfeeding;
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
        microchip.hashCode ^
        birthday.hashCode ^
        lastvetvisit.hashCode ^
        lastgrooming.hashCode ^
        lastwalk.hashCode ^
        lastbath.hashCode ^
        lastmedication.hashCode ^
        lastplaytime.hashCode ^
        lastfeeding.hashCode;
  }
}
