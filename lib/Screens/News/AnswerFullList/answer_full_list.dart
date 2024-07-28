import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/News/NewsItem/news_item.dart';
import 'package:untitled/Screens/News/commentary_item.dart';
import 'package:untitled/Screens/News/input_widget.dart';
import 'package:untitled/Screens/News/news_app_bar.dart';
import 'package:untitled/Screens/News/wait_boxes.dart';
import 'package:untitled/components/models/paginated_news_list.dart';
import 'package:untitled/ServiceItems/network_service.dart';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';

part 'bloc/answer_full_list_bloc.dart';
part 'bloc/answer_full_list_event.dart';
part 'bloc/answer_full_list_state.dart';

part 'view/answer_full_list_screen.dart';