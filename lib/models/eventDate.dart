class EventDate {
  final String note;
  final String user;
  final String date;
  final String holiday;
  final String location;
  final String motivation;

  EventDate({
    this.note,
    this.user,
    this.date,
    this.holiday,
    this.location,
    this.motivation,
  });

  factory EventDate.fromJson(Map<String, dynamic> parsedJson) {
    return new EventDate(
      note:       parsedJson["ZNOTE"],
      user:       parsedJson["ZUSERNAME"],
      date:       parsedJson["ZDATA"],
      holiday:    parsedJson["ZFESTIVO"],
      location:   parsedJson["ZLUOGO"],
      motivation: parsedJson["ZCAUSALE"],
    );
  }

  String get getNote       => note;
  String get getUser       => user;
  String get getDate       => date;
  String get getHoliday    => holiday;
  String get getLocation   => location;
  String get getMotivation => motivation;
}
