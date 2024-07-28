import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/Screens/News/format_data.dart';
import 'package:untitled/components/widgets/image_viewer.dart';
import 'package:untitled/components/widgets/send_claim.dart';
import 'package:untitled/components/models/paginated_news_list.dart';
import 'package:untitled/generated/locale_keys.g.dart';

Widget commentaryItem({
  required BuildContext context,
  required CommentaryFullItem item,
  double size = 40,
  Widget? answerList,
  required Function onTapAction
})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      if(prefs.getInt("userId") == item.commentary!.user!.id!){
                        return;
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleUser(
                                anketa: null,
                                targetUserId: item.commentary!.user!.id!
                            ),
                          )
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90.0),
                      child: SizedBox(
                          width: size,
                          height: size,
                          child: displayImageMiniature(
                              item.commentary?.user?.avatar?.preview ?? ""
                            //chatInfo.userAvatar.toString()
                          )
                      ),
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.commentary?.user?.name ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            //height: 1.4,
                            color: const Color.fromARGB(255, 33, 33, 33),
                          ),
                        ),
                        Text(
                          item.commentary?.text ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.4,
                            color: const Color.fromARGB(180, 33, 33, 33),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              formatDate(item.commentary?.leftDate ?? ""),
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                height: 1.4,
                                color: const Color.fromARGB(255, 157, 157, 157),
                              ),
                            ),
                            const SizedBox(width: 16,),
                            GestureDetector(
                              onTap: (){
                                onTapAction();

                              },
                              child: Text(
                                LocaleKeys.news_reply.tr(),//"Ответить",
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  height: 1.4,
                                  color: const Color.fromARGB(255, 157, 157, 157),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  size: 18,
                ),
                offset: const Offset(0, 50),
                shape: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                itemBuilder: (itemContext) {
                  return [
                    PopupMenuItem(
                      onTap: () async {
                        Future.delayed(
                          const Duration(seconds: 0),
                          () => SendClaim(
                            claimObjectId: item.commentary!.id!,
                            type: ClaimType.commentary
                          ).ShowAlertDialog(context)
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.block),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            LocaleKeys.chat_report.tr(),
                          )
                        ],
                      ),
                    )
                  ];
                }
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 48),
        child: (answerList == null) ? Container() : answerList
      )
    ],
  );
}