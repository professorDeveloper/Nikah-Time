import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Chat/bloc/chat_settings_bloc/chat_settings_bloc.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';

class ChatSettings extends StatelessWidget
{
  final Widget? goNextButton;

  const ChatSettings({
    this.goNextButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocProvider(
        create: (context) => ChatSettingsBloc(),
        child: BlocBuilder<ChatSettingsBloc, ChatSettingsState>(
          builder: (context, state){
            state as ChatSettingsInitial;

            switch(state.screenState){
              case ScreenState.preload:
                context.read<ChatSettingsBloc>().add(
                    LoadProfileInfo()
                );

                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ScreenState.processed:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ScreenState.ready:
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Уведомления",
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: const Color.fromARGB(255, 33, 33, 33),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Дублировать уведомления на почту",
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 33, 33, 33),
                                ),
                              ),
                              Switch(
                                  value: (context.read<ChatSettingsBloc>().state as ChatSettingsInitial).userData!.emailNotification.isEnabled,
                                  onChanged: (enabled) {
                                    context.read<ChatSettingsBloc>().add(NotificationAction());
                                  }
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                decoration: CustomInputDecoration(
                                  hintText: "Email",
                                ).GetDecoration(),
                                onChanged: (value) {
                                  context.read<ChatSettingsBloc>().add(
                                      InputAction(
                                        data: value,
                                      )
                                  );
                                },
                                //controller: TextEditingController(text: state.email),
                                onSubmitted: (value) {
                                  context.read<ChatSettingsBloc>().add(
                                      InputAction(
                                        data: value,
                                      )
                                  );
                                },
                              ),
                              Visibility(
                                  visible: (context.read<ChatSettingsBloc>().state as ChatSettingsInitial).emailError.isNotEmpty,
                                  child: Text(
                                    (context.read<ChatSettingsBloc>().state as ChatSettingsInitial).emailError,
                                    style: GoogleFonts.rubik(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  )
                              ),
                              if(goNextButton != null) goNextButton!,
                            ],
                          ),
                        ]
                    ),
                  ),
                );
              case ScreenState.error:
                return Container();
            }
          },
        ),
      ),
    );
  }

}