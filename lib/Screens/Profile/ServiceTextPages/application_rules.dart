import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/widgets/custom_appbar.dart';

class ApplicationRulesScreen extends StatefulWidget{
  @override
  State<ApplicationRulesScreen> createState() => _ApplicationRulesScreenState();
}

class _ApplicationRulesScreenState extends State<ApplicationRulesScreen> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: const CustomAppBar(),
        body:  Container (
          margin: const EdgeInsets.only(left: 16, right: 16),
          width: double.infinity,
          //margin: EdgeInsets.only(top: 104),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16,),
                            Text(
                              'Правила пользования приложением',
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: const Color.fromARGB(255,33,33,33),
                              ),
                            ),
                            const SizedBox(height: 24,),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color.fromARGB(255,33,33,33),
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: '1.', style: GoogleFonts.rubik(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: const Color.fromARGB(255,33,33,33),
                                    )
                                  ),
                                  TextSpan(text: 'Настоящие Правила представляют собой соглашение между Разработчиком и Пользователем (далее вместе именуемые «Стороны») и регулируют права и обязанности Разработчика и Пользователя в связи с использованием Приложения.'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24,),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color.fromARGB(255,33,33,33),
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: '2.', style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: const Color.fromARGB(255,33,33,33),
                                  )
                                  ),
                                  const TextSpan(text:
                                  'Настоящие Правила являются официальным типовым документом Разработчиков. Настоящие Правила применяются к указанным отношениям в случае, если Разработчик не утвердил и не применяет свои собственные Правила оказания услуг, ссылка на которые предоставляется Пользователям в окне запуска Приложения и в настройках Приложения.'
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24,),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color.fromARGB(255,33,33,33),
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: '3.', style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: const Color.fromARGB(255,33,33,33),
                                  )
                                  ),
                                  const TextSpan(text:
                                  'Действующая редакция Правил, являющихся публичным документом, разработана Администрацией Сайта и доступна любому пользователю сети Интернет при переходе по гипертекстовой ссылке «Правила оказания услуг разработчика приложения».\nАдминистрация Сайта вправе вносить изменения в настоящие Правила. При внесении изменений в Правила Администрация Сайта уведомляет об этом пользователей путем размещения новой редакции Правил не позднее, чем за [10] дней до вступления в силу соответствующих изменений. Предыдущие редакции Правил хранятся в архиве документации Администрации Сайта.'
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24,),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color.fromARGB(255,33,33,33),
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: '4.', style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: const Color.fromARGB(255,33,33,33),
                                  )
                                  ),
                                  const TextSpan(text:
                                  'Положения настоящих Правил рассматриваются как публичная оферта в соответствии со ст. 437 Гражданского кодекса Российской Федерации. Пользователь обязан полностью ознакомиться с настоящими Правилами до первого запуска Приложения. Запуск Приложения Пользователем означает полное и безоговорочное принятие Пользователем настоящих Правил в соответствии со ст. 438 Гражданского кодекса Российской Федерации. Положения настоящих Правил могут быть приняты только в целом без каких-либо изъятий.'
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24,),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color.fromARGB(255,33,33,33),
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: '5.', style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: const Color.fromARGB(255,33,33,33),
                                  )
                                  ),
                                  const TextSpan(text:
                                  'Ссылка на настоящие Правила после запуска Приложения доступна в настройках Приложения, во вкладке «Информация о разработчике». Пользователь обязан время от времени проверять текущую версию настоящих Правил в настройках Приложения на предмет внесения изменений и/или дополнений. Продолжение использования Приложения Пользователем после вступления в силу соответствующих изменений настоящих Правил означает принятие и согласие Пользователя с такими изменениями и/или дополнениями.'
                                  ),
                                ],
                              ),
                            ),

                          ]
                      )
                  )
              ),
            ],
          ),
        ),
      );
    }
}