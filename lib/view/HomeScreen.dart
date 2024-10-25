import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/AttendenceController.dart';
import '../helper/Database.dart';
import '../helper/FirebaseService.dart';
import '../model/attendencmodel.dart';

class HomeScreen extends StatelessWidget {
  final AttendanceController controller = Get.put(AttendanceController(SQLiteService(), FirebaseService()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: () {
              controller.syncWithFirebase();
              Get.snackbar("Sync", "Data synced with Firebase successfully!");
            },
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.attendanceList.length,
        itemBuilder: (context, index) {
          var record = controller.attendanceList[index];
          return ListTile(
            title: Text(record.studentName),
            subtitle: Text(record.date.toLocal().toString()),
            leading: Icon(
              record.isPresent ? Icons.check_circle : Icons.cancel,
              color: record.isPresent ? Colors.green : Colors.red,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _showEditRecordDialog(context, record);
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    controller.deleteRecord(record.id);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecordDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRecordDialog(BuildContext context) {
    final nameController = TextEditingController();
    bool? isPresent; // Change to nullable boolean

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Attendance Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Student Name'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Present'),
                  ElevatedButton(
                    onPressed: () {
                      isPresent = true;
                    },
                    child: const Text('Yes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      isPresent = false;
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && isPresent != null) { // Ensure a name is entered and presence is selected
                  var newRecord = AttendanceRecord(
                    id: DateTime.now().toString(),
                    studentName: nameController.text,
                    date: DateTime.now(),
                    isPresent: isPresent!,
                  );
                  controller.addRecord(newRecord);
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar("Error", "Please enter a name and select present/absent."); // Error message if validation fails
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditRecordDialog(BuildContext context, AttendanceRecord record) {
    final nameController = TextEditingController(text: record.studentName);
    bool? isPresent = record.isPresent; // Keep the current presence status

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Attendance Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Student Name'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Present'),
                  ElevatedButton(
                    onPressed: () {
                      isPresent = true;
                    },
                    child: const Text('Yes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      isPresent = false;
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && isPresent != null) {
                  var updatedRecord = AttendanceRecord(
                    id: record.id, // Keep the same ID for the existing record
                    studentName: nameController.text,
                    date: record.date, // Keep the same date
                    isPresent: isPresent!,
                  );
                  controller.updateRecord(updatedRecord);
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar("Error", "Please enter a name and select present/absent.");
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
