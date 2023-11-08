import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pet_app/core/constants/firebase_constants.dart';
import 'package:pet_app/core/failure.dart';
import 'package:pet_app/core/providers/firebase_providers.dart';
import 'package:pet_app/core/type_defs.dart';
import 'package:pet_app/models/calendar_model.dart';

final calendarRepoProvider = Provider((ref) {
  return CalendarRepo(firestore: ref.watch(firestoreProvider));
});

class CalendarRepo {
  final FirebaseFirestore _firestore;
  CalendarRepo({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _calendars =>
      _firestore.collection(FirebaseConstants.calendarsCollection);

  FutureVoid addCalendar(CalendarModel calendar) async {
    try {
      String calendarID;
      calendarID = _calendars.doc().id;
      calendar = calendar.copyWith(id: calendarID);
      return right(_calendars.doc(calendarID).set(calendar.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Check in Pets collection if any pets has the same petOwnerid. Should add in the list.
  Stream<List<CalendarModel>> getUserCalendars(String uid) {
    return _calendars.where('ownerid', isEqualTo: uid).snapshots().map((event) {
      List<CalendarModel> calendars = [];
      for (var doc in event.docs) {
        calendars
            .add(CalendarModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return calendars;
    });
  }

  Stream<Map<DateTime, List<CalendarModel>>> getUserCalendarsList(String uid) {
    return _calendars.where('ownerid', isEqualTo: uid).snapshots().map((event) {
      List<CalendarModel> calendars = [];
      Map<DateTime, List<CalendarModel>> finalcalendars = {};
      for (var doc in event.docs) {
        calendars
            .add(CalendarModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      finalcalendars = CalendarModel.convertToCalendarMap(calendars);
      return finalcalendars;
    });
  }

  Stream<CalendarModel> getCalendarByID(String calendarID) {
    return _calendars.doc(calendarID).snapshots().map(
        (event) => CalendarModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid deleteCalendar(CalendarModel calendar) async {
    try {
      return right(_calendars.doc(calendar.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid setCalendar(CalendarModel calendar) async {
    try {
      return right(_calendars.doc(calendar.id).set(calendar.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editPet(CalendarModel pet) async {
    try {
      return right(_calendars.doc(pet.id).update(pet.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
