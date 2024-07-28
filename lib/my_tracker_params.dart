import 'dart:io';

class MyTrackerSDK
{
  static const String _googleKeySDK = "31093782481966057349";
  static const String _appleKeySDK  = "06496796694342357190";

  static String getKeySDK(){
    if(Platform.isIOS)
    {
      return _appleKeySDK;
    }else{
      return _googleKeySDK;
    }
  }
}
