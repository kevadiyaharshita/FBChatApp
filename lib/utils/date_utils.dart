String getWeekDay({required int day}) {
  String date = '';
  switch (day) {
    case 1:
      date = "Monday";
      break;
    case 2:
      date = "Tuesday";
      break;
    case 3:
      date = "Wednesday";
      break;
    case 4:
      date = "ThursDay";
      break;
    case 5:
      date = "Friday";
      break;
    case 6:
      date = "Saturday";
      break;
    case 7:
      date = "Sunday";
      break;
  }
  return date;
}
