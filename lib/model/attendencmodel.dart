class AttendanceRecord {
  String id;
  String studentName;
  DateTime date;
  bool isPresent;

  AttendanceRecord({required this.id, required this.studentName, required this.date, required this.isPresent});

  Map<String, dynamic> toMap() => {
    'id': id,
    'studentName': studentName,
    'date': date.toIso8601String(),
    'isPresent': isPresent ? 1 : 0,
  };

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) => AttendanceRecord(
    id: map['id'],
    studentName: map['studentName'],
    date: DateTime.parse(map['date']),
    isPresent: map['isPresent'] == 1,
  );
}
