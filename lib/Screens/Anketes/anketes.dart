
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:customizable_multiselect_field/models/customizable_multiselect_dialog_options.dart';
import 'package:customizable_multiselect_field/models/customizable_multiselect_widget_options.dart';
import 'package:customizable_multiselect_field/models/data_source.dart';
import 'package:customizable_multiselect_field/models/data_source_options.dart';
import 'package:customizable_multiselect_field/widgets/customizable_multiselect_Field.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laravel_echo2/laravel_echo2.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Payment/payment.dart';
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart';
import 'package:untitled/components/widgets/create_chat.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/components/widgets/image_viewer.dart';
import 'package:untitled/components/widgets/likeAnimation.dart';
import 'package:untitled/components/items/nationality_list.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/widgets/send_claim.dart';
import 'package:untitled/components/items/strings_list.dart';
import 'package:untitled/components/models/paginated_user_list.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';
import 'package:untitled/main_page_custom_icon_icons.dart';

part 'bloc/anketes_bloc.dart';
part 'bloc/anketes_event.dart';
part 'bloc/anketes_state.dart';

part 'view/anketes_cross_match.dart';
part 'view/anketes_feed.dart';
part 'view/anketes_horizontal_view.dart';
part 'view/anketes_vertical_grid_view.dart';
part 'view/expanded_filter.dart';
part 'view/single_user.dart';


enum AnketasScreenState
{
  hold,
  preload,
  loading,
  ready,
  error,
  noMoreItem,
}