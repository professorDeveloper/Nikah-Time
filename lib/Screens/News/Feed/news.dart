import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/News/NewsItem/news_item.dart';
import 'package:untitled/Screens/News/action_button.dart';
import 'package:untitled/Screens/News/format_data.dart';
import 'package:untitled/Screens/News/news_app_bar.dart';
import 'package:untitled/Screens/News/wait_boxes.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/paginated_news_list.dart';
import 'package:untitled/main_page_custom_icon_icons.dart';

import '../../../components/widgets/image_viewer.dart';


import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';

part 'bloc/news_bloc.dart';
part 'bloc/news_event.dart';
part 'bloc/news_state.dart';

part 'view/news_page.dart';


enum NewsScreenStateEnum
{
  hold,
  preload,
  loading,
  ready,
  error,
  noMoreItem,
}