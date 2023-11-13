// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CalendarModel {
  final String? ownerid;
  final String? id;
  final String title;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  // final DateTime? startTime;
  // final DateTime? endTime;
  final String? appointmentType;
  final String? petName;
  CalendarModel({
    this.ownerid,
    this.id,
    required this.title,
    this.startDateTime,
    this.endDateTime,
    required this.appointmentType,
    required this.petName,
  });

  CalendarModel copyWith({
    String? ownerid,
    String? id,
    String? title,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? appointmentType,
    String? petName,
  }) {
    return CalendarModel(
      ownerid: ownerid ?? this.ownerid,
      id: id ?? this.id,
      title: title ?? this.title,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      appointmentType: appointmentType ?? this.appointmentType,
      petName: petName ?? this.petName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ownerid': ownerid,
      'id': id,
      'title': title,
      'startDateTime': startDateTime?.millisecondsSinceEpoch,
      'endDateTime': endDateTime?.millisecondsSinceEpoch,
      'appointmentType': appointmentType,
      'petName': petName,
    };
  }

  static Map<DateTime, List<CalendarModel>> convertToCalendarMap(
      List<CalendarModel> calendarList) {
    Map<DateTime, List<CalendarModel>> resultMap = {};

    for (var calendarModel in calendarList) {
      DateTime? startDateTime = calendarModel.startDateTime;

      if (startDateTime != null) {
        print(startDateTime.year);
        print(startDateTime.month);
        print(startDateTime.day);
        DateTime startDay = DateTime(
                startDateTime.year, startDateTime.month, startDateTime.day, 8)
            .toUtc();
        print(startDay);
        if (resultMap.containsKey(startDay)) {
          resultMap[startDay]!.add(calendarModel);
        } else {
          resultMap[startDay] = [calendarModel];
        }
      }
    }

    return resultMap;
  }

  factory CalendarModel.fromMap(Map<String, dynamic> map) {
    return CalendarModel(
      ownerid: map['ownerid'] != null ? map['ownerid'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] as String,
      startDateTime: map['startDateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDateTime'] as int)
          : null,
      endDateTime: map['endDateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDateTime'] as int)
          : null,
      appointmentType: map['appointmentType'] != null
          ? map['appointmentType'] as String
          : null,
      petName: map['petName'] != null ? map['petName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarModel.fromJson(String source) =>
      CalendarModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CalendarModel(ownerid: $ownerid, id: $id, title: $title, startDateTime: $startDateTime, endDateTime: $endDateTime, appointmentType: $appointmentType, petName: $petName)';
  }

  @override
  bool operator ==(covariant CalendarModel other) {
    if (identical(this, other)) return true;

    return other.ownerid == ownerid &&
        other.id == id &&
        other.title == title &&
        other.startDateTime == startDateTime &&
        other.endDateTime == endDateTime &&
        other.appointmentType == appointmentType &&
        other.petName == petName;
  }

  @override
  int get hashCode {
    return ownerid.hashCode ^
        id.hashCode ^
        title.hashCode ^
        startDateTime.hashCode ^
        endDateTime.hashCode ^
        appointmentType.hashCode ^
        petName.hashCode;
  }
}
