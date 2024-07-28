import 'package:easy_localization/easy_localization.dart' as locale;
import 'package:untitled/generated/locale_keys.g.dart';



String formatDate(String date)
{
  DateTime messageDt = DateTime.now();

  Duration duration = messageDt
      .difference(
        locale.DateFormat('yyyy-MM-ddTHH:mm:ss')
          .parse(date)
          .add(DateTime.now().timeZoneOffset))
      .abs();
  if(duration.inDays > 0){
    return "${duration.inDays}" + LocaleKeys.news_timeAgo_day.tr();
  }else if(duration.inHours > 0){
    return "${duration.inHours}" + LocaleKeys.news_timeAgo_hour.tr();
  }else if(duration.inMinutes > 0){
    return "${duration.inMinutes}" + LocaleKeys.news_timeAgo_min.tr();
  }

  return  LocaleKeys.news_timeAgo_now.tr();
}


String formatDigits(int value)
{
  String retVal = "";

  if(value < 1000)
    {
      retVal = value.toString();
    }
  else if (value >= 1000 && value < 1000000)
    {
      retVal = "${value ~/ 1000} " + LocaleKeys.news_views_thousand.tr();
    }
  else if (value >= 1000000 && value < 1000000000)
    {
      retVal = "${value ~/ 1000000} " + LocaleKeys.news_views_million.tr();
    }
  else if (value >= 1000000000)
    {
      retVal = "${value ~/ 1000000000} " + LocaleKeys.news_views_billion.tr();
    }

  return retVal;
}