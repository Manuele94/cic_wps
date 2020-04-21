abstract class Enum<T> {
  final T value;

  const Enum(this.value);
}

class AttendanceTypeAb<String> extends Enum<String> {
  const AttendanceTypeAb(String val) : super(val);

  static const AttendanceTypeAb ABSENCE = const AttendanceTypeAb("Absence");
  static const AttendanceTypeAb REMOTE_WORKING =
      const AttendanceTypeAb("Remote Working");
  static const AttendanceTypeAb BUSINESS_TRIP =
      const AttendanceTypeAb("Business Trip");
  static const AttendanceTypeAb NOT_DEFINED =
      const AttendanceTypeAb("Not Defined");
  static const AttendanceTypeAb HOLIDAY = const AttendanceTypeAb("Holiday");
  static const AttendanceTypeAb FLAG_CANCELLAZIONE =
      const AttendanceTypeAb("C");
}
