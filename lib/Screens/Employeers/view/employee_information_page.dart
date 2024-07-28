part of '../employee_information.dart';

class EmployeeInformation extends StatefulWidget {
  const EmployeeInformation();

  @override
  State<EmployeeInformation> createState() => _EmployeeInformationState();
}

class _EmployeeInformationState extends State<EmployeeInformation> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeerBloc>(
      create: (context) => EmployeerBloc(),
      child: BlocBuilder<EmployeerBloc, EmployeerState>(
        buildWhen: (curr, prev) => (curr as EmployeerInitial).screenState != EmployerScreenState.extendedReady,
        builder: (context, state){
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              width: double.infinity,
              child:  SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //==========================
                        //О нас
                        Text(
                          LocaleKeys.profileScreen_settings_about.tr(),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: const Color.fromARGB(255, 33, 33, 33),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        dynamicBody(context, state as EmployeerInitial),
                      ]
                  )
              ),
            ),
          );
        },
      ),
    );

  }

  Widget dynamicBody(BuildContext context, EmployeerInitial state)
  {
    switch(state.screenState)
    {
      case EmployerScreenState.preload:
        context.read<EmployeerBloc>().add(
            const LoadDataEvent()
        );
        return waitBox();
      case EmployerScreenState.error:
        return errorBox();
      case EmployerScreenState.extendedReady:
      case EmployerScreenState.ready:
        return showOurTeam(context, state);
      default:
        return Container();
    }
  }


  Widget showOurTeam(BuildContext context, EmployeerInitial state)
  {
    List<Widget> list = [];

    for(final items in state.employerList)
    {
      list.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            items.position,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: const Color.fromARGB(255, 33, 33, 33),
            ),
          ),
        )
      );

      for(final item in items.items)
      {
        list.add(peopleCard(context, item: item));
        list.add(const SizedBox(height: 8));
        list.add(
            const Divider(
              thickness: 1,
              height: 16,
            )
        );
      }
    }
    list.removeLast();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget waitBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Center(
            child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(Color.fromRGBO(0, 0xcf, 0x91, 1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget errorBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Text(
          LocaleKeys.entering_recoveryBy_error.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: const Color.fromRGBO(0, 0xcf, 0x91, 1),
          ),
        ),
      ],
    );
  }


  Widget peopleCard(BuildContext buildContext, {required PeopleCard item})
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 120,
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(12.0),
                  child: displayPhotoOrVideo(
                      buildContext,
                      item.image.toString(),
                      items: [item.image.toString()],
                      initPage: 0,
                      photoOwnerId: item.id
                  ),
                )
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                children: [
                  expandedPeopleCard(context, item: item),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (context){
                              return StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return Material(
                                    child: SafeArea(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                                        child: SingleChildScrollView(
                                          child: BlocProvider(
                                            create: (context) => EmployeerBloc(),
                                            child: BlocBuilder<EmployeerBloc, EmployeerState>(
                                              builder: (context, state){
                                                state as EmployeerInitial;
                                                switch(state.screenState)
                                                {
                                                  case EmployerScreenState.preload:
                                                    context.read<EmployeerBloc>().add(
                                                        LoadSelectedDataEvent(id: item.id)
                                                    );
                                                    return waitBox();
                                                  case EmployerScreenState.error:
                                                    return errorBox();
                                                  default:
                                                    return expandedPeopleCard(context, item: state.selectedPeopleItem ?? item);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          );
                        },
                        child: Text(
                          LocaleKeys.user_more.tr(),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color.fromARGB(255, 00, 207, 145),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )

          ],
        ),
      ],
    );
  }

  Widget expandedPeopleCard(BuildContext context, {required PeopleCard item})
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.name,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),

        Text(
          item.workPosition,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.justify,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Visibility(
            visible: item.price != null,
            child: Column(
              children: [
                Text(
                  LocaleKeys.profileScreen_settings_price.tr() + " - ${item.price.toString()}₽", //item.price.toString(),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            )
        ),
        Visibility(
          visible: item.url != null,
          child: GestureDetector(
            onTap: () async {
              _launchInBrowser(item.url ?? "");
            },
            child: Text(
              LocaleKeys.profileScreen_settings_link.tr(),
              textAlign: TextAlign.start,
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: const Color.fromARGB(255, 00, 207, 145),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Visibility(
          visible: item.phone != null,
          child: GestureDetector(
            onTap: () async {
              SnackBar snackBar = SnackBar(
                content: Text(LocaleKeys.profileScreen_settings_phone_copied.tr()),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              Clipboard.setData(ClipboardData(text: item.phone ?? ""));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: LocaleKeys.profileScreen_settings_link_second
                        .tr() + " : " + (item.phone ?? ""),
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color.fromARGB(255, 00, 207, 145),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Visibility(
            visible: item.description != null,
            child: Column(
              children: [
                Text(
                  item.description ?? "", //item.price.toString(),
                  textDirection: TextDirection.ltr,
                  maxLines: 50,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.4,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            )
        ),


      ],
    );
  }

}


