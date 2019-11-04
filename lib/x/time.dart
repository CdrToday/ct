String display(int ts) {
  DateTime _now = DateTime.now();
  DateTime t = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
  
  String year = t.year.toString();
  String month = t.month.toString();
  String day = t.day.toString();
  String hour = t.hour.toString();
  String minute = t.minute.toString();
  String weekday = t.weekday.toString();

  if (month.length == 1) month = " $month";
  if (day.length == 1) day = " $day";
  if (hour.length == 1) hour = "0$hour";
  if (minute.length == 1) minute = "0$minute";

  switch (weekday) {
    case '1':
    weekday = '周一';
    break;
    
    case '2':
    weekday = '周二';
    break;

    case '3':
    weekday = '周三';
    break;

    case '4':
    weekday = '周四';
    break;

    case '5':
    weekday = '周五';
    break;

    case '6':
    weekday = '周六';
    break;

    case '7':
    weekday = '周日';
    break;
  }
  
  if (_now.year.toString() != year) {
    return "$year年$month月$day日 $hour:$minute";
  } else if (_now.difference(t).inDays > 6) {
    return "$month月$day日 $hour:$minute";
  } else if (_now.difference(t).inDays > 1) {
    return "$weekday $hour:$minute";
  } else if (_now.day != t.day) {
    return "昨天 $hour:$minute";
  } else {
    return "$hour:$minute";
  }
}
