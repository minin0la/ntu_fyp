import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/providers/storage_repo_providers.dart';
import 'package:pet_app/core/utils.dart';
import 'package:pet_app/features/auth/controller/auth_controller.dart';
import 'package:pet_app/features/calendar/repo/calendar_repo.dart';
import 'package:pet_app/models/calendar_model.dart';
import 'package:routemaster/routemaster.dart';

final calendarProvider = StateProvider<CalendarModel?>((ref) => null);

final userCalendarsProvider = StreamProvider((ref) {
  final calendarController = ref.watch(calendarControllerProvider.notifier);
  return calendarController.getUserCalendars();
});
final userCalendarsListProvider = StreamProvider((ref) {
  final calendarController = ref.watch(calendarControllerProvider.notifier);
  return calendarController.getUserCalendarsList();
});

final getCalendarByIDProvider = StreamProvider.family((ref, String calendarID) {
  final calendarController = ref.watch(calendarControllerProvider.notifier);
  return calendarController.getCalendarByID(calendarID);
});

final calendarControllerProvider =
    StateNotifierProvider<CalendarController, bool>((ref) {
  final calendarRepo = ref.watch(calendarRepoProvider);
  final storageRepo = ref.watch(storageRepoProvider);
  return CalendarController(
      calendarRepo: calendarRepo, ref: ref, storageRepo: storageRepo);
});

final calendarRoutineProvider =
    StateNotifierProvider.family<CalendarRoutineController, bool, List>(
        (ref, time) {
  return CalendarRoutineController(time);
});

class CalendarRoutineController extends StateNotifier<bool> {
  CalendarRoutineController(this.time) : super(false) {
    checkRoutine();
  }
  final List time;

  void checkRoutine() {
    if (DateTime.now().difference(time[0]).inSeconds > time[1]) {
      state = true;
    }
    Future.delayed(const Duration(seconds: 5), checkRoutine);
  }
}

class CalendarController extends StateNotifier<bool> {
  final CalendarRepo _calendarRepo;
  final Ref _ref;
  final StorageRepo _storageRepo;
  CalendarController({
    required CalendarRepo calendarRepo,
    required Ref ref,
    required StorageRepo storageRepo,
  })  : _calendarRepo = calendarRepo,
        _ref = ref,
        _storageRepo = storageRepo,
        super(false);

  void addCalendar(String title, DateTime startDateTime, DateTime endDateTime,
      String appointmentType, String petName, BuildContext context) async {
    state = true;
    // final uid = _ref.read(userProvider)?.uid ?? '';
    CalendarModel calendar = CalendarModel(
      ownerid: _ref.read(userProvider)!.uid,
      title: title,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      appointmentType: appointmentType,
      petName: petName,
    );
    final res = await _calendarRepo.addCalendar(calendar);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), ((r) {
      Routemaster.of(context).pop();
    }));
  }

  void deleteCalendar(CalendarModel calendar, BuildContext context) async {
    final res = await _calendarRepo.deleteCalendar(calendar);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, "Calendar deleted"));
  }

  // Stream the list of calendars from the repo
  Stream<List<CalendarModel>> getUserCalendars() {
    final uid = _ref.read(userProvider)!.uid;
    return _calendarRepo.getUserCalendars(uid);
  }

  Stream<Map<DateTime, List<CalendarModel>>> getUserCalendarsList() {
    final uid = _ref.read(userProvider)!.uid;
    return _calendarRepo.getUserCalendarsList(uid);
  }

  Stream<CalendarModel> getCalendarByID(String calendarID) {
    return _calendarRepo.getCalendarByID(calendarID);
  }

  void setCalendar(CalendarModel calendar, BuildContext context) async {
    final res = await _calendarRepo.setCalendar(calendar);
    res.fold((l) => showSnackBar(context, l.message), (r) {});
  }
}
