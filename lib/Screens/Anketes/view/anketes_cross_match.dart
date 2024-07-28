part of '../anketes.dart';

class CrossMatch extends StatefulWidget {
  CrossMatch(
    this._person,
    this.userId,
    this.userGender, {Key? key}
  ) : super(key: key);

  final UserProfileData _person;
  final String userGender;
  final int userId;

  @override
  State<CrossMatch> createState() => _CrossMatchState();
}

class _CrossMatchState extends State<CrossMatch> with TickerProviderStateMixin {
  double _sparklesAngle = 0.0;
  final duration = const Duration(milliseconds: 3000);
  late Random random;
  late AnimationController sparklesAnimationController;
  late Animation sparklesAnimation;
  late FutureBuilder _personMainPhotoFutureBuilder;

  bool needShowAnimation = true;

  @override
  initState() {
    super.initState();

    _personMainPhotoFutureBuilder =
        displayImageMiniature(widget._person.photos![0].toString());

    random = Random();

    sparklesAnimationController =
        AnimationController(vsync: this, duration: duration);
    sparklesAnimation = CurvedAnimation(
        parent: sparklesAnimationController, curve: Curves.easeIn);
    sparklesAnimation.addListener(() {
      setState(() {});
    });

    _sparklesAngle = random.nextDouble() * (2 * pi);

    runSparkAnimation();
  }

  void runSparkAnimation() {
    Timer.run(() {
      sparklesAnimationController.forward(from: 0.0);
    });
  }

  List<Widget> Sparks(String imagePath, int count, double width, double height,
      double angle, double radiusFactor) {
    List<Widget> sparkWidgetsList = [];

    final photoHeight = MediaQuery.of(context).size.height / 3;
    final photoWidth = photoHeight * 0.7128;

    var sparkleRadius = (sparklesAnimationController.value * radiusFactor);
    var sparklesOpacity = (1 - sparklesAnimation.value);

    for (int i = 0; i < count; ++i) {
      var imageSparkWidth = width;
      var imageSparkHeight = height;
      var currentAngle = angle + ((2 * pi) / count) * i;
      var sparklesWidget = Positioned(
        child: Transform.rotate(
            angle: currentAngle - pi / 2,
            child: Opacity(
                opacity: sparklesOpacity.toDouble(),
                child: Image.asset(imagePath,
                    width: imageSparkWidth, height: imageSparkHeight))),
        left: (sparkleRadius * cos(currentAngle)) +
            (photoWidth / 2) -
            (imageSparkWidth / 2),
        top: (sparkleRadius * sin(currentAngle)) + 20,
      );

      sparkWidgetsList.add(sparklesWidget);
    }

    return sparkWidgetsList;
  }

  Widget userPhotoWithSpark(CrossMatch crossMatchwidget) {
    final photoHeight = MediaQuery.of(context).size.height / 3;
    final photoWidth = photoHeight * 0.7128;

    var stackChildren = <Widget>[];

    // stackChildren.addAll(
    //     Sparks("assets/icons/spark1.png", 6, 80, 80, _sparklesAngle, 500));
    //
    // stackChildren.addAll(
    //     Sparks("assets/icons/spark2.png", 4, 60, 60, _sparklesAngle + 16, 600));
    //
    // stackChildren.addAll(
    //     Sparks("assets/icons/spark3.png", 3, 20, 20, _sparklesAngle + 46, 700));

    stackChildren.add(Container(
        height: photoHeight,
        width: photoWidth,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Color.fromARGB(255, 236, 235, 235),
        ),
        child: (crossMatchwidget._person.photos == null ||
                crossMatchwidget._person.photos![0] == "null")
            ? const Icon(Icons.photo_camera, color: Color.fromRGBO(230, 230, 230, 1), size: 60)
            : ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: _personMainPhotoFutureBuilder)));

    var widget = Stack(
      alignment: FractionalOffset.center,
      children: stackChildren,
    );
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 130,
                ),
                Stack(
                  children: [
                    // Container(
                    //   child: Image.asset("assets/icons/match_background.png"),
                    // ),
                    Align(
                        alignment: AlignmentDirectional.center,
                        child: userPhotoWithSpark(widget))
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  child: const Text(
                    // "${widget._person.firstName} тоже вами интересуется!\nВы можете написать ${(widget.userProfileData.gender == "male") ? "первым" : "первой"}.",
                    LocaleKeys.usersScreen_match,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color.fromARGB(255, 33, 33, 33),
                    ),
                  ).tr(
                      namedArgs: {'firstName': widget._person.firstName ?? ""},
                      gender: ""//widget.userGender
                  ),
                ),
                const SizedBox(
                  height: 42,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.usersScreen_writeMessage,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ).tr(),
                      onPressed: () async {
                        CreateChat(this.context, widget.userGender, widget.userId)
                            .createChatWithUser(widget._person.id!);
                      }),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  width: double.infinity,
                  child: MaterialButton(
                      height: 56,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: const BorderSide(
                            width: 1, color: Color.fromARGB(255, 0, 207, 145)),
                      ),
                      child: const Text(
                        LocaleKeys.usersScreen_continueViewing,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 207, 145),
                        ),
                      ).tr(),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
            Builder(
                builder: (context) {
                  if (needShowAnimation) {
                    return LikeAnimationWidget(
                      true,
                      onCompleted: (){
                        needShowAnimation = false;
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}
