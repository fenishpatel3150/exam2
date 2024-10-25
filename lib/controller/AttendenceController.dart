import 'package:get/get.dart';
import '../helper/Database.dart';
import '../helper/FirebaseService.dart';
import '../model/attendencmodel.dart';

class AttendanceController extends GetxController {
  var attendanceList = <AttendanceRecord>[].obs;
  final SQLiteService sqliteService;
  final FirebaseService firebaseService;

  AttendanceController(this.sqliteService, this.firebaseService);

  Future<void> addRecord(AttendanceRecord record) async {
    await sqliteService.addRecord(record);
    attendanceList.add(record);
    update();
  }

  Future<void> fetchRecords() async {
    attendanceList.value = await sqliteService.getRecords();
  }

  Future<void> updateRecord(AttendanceRecord record) async {
    await sqliteService.updateRecord(record);
    int index = attendanceList.indexWhere((r) => r.id == record.id);
    if (index != -1) attendanceList[index] = record;
    update();
  }

  Future<void> deleteRecord(String id) async {
    try {
      await sqliteService.deleteRecord(id);
      await firebaseService.deleteRecord(id);
      attendanceList.removeWhere((r) => r.id == id);
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to delete record: $e");
    }
  }

  Future<void> filterByDate(DateTime date) async {
    attendanceList.value = await sqliteService.filterRecordsByDate(date);
  }

  Future<void> syncWithFirebase() async {
    await firebaseService.syncRecords(attendanceList);
  }
}
