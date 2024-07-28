import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/widgets/custom_appbar.dart';

class TermsOfRulesScreen extends StatefulWidget{
  @override
  State<TermsOfRulesScreen> createState() => _TermsOfRulesScreenState();
}

/*TextSpan(
  text: '\n'
),*/

class _TermsOfRulesScreenState extends State<TermsOfRulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: const CustomAppBar(),
      body:  SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 16,),
                Text(
                  'Правила пользования и поведения в приложении NikahTime.',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color.fromARGB(255,33,33,33),
                  ),
                ),
                const SizedBox(height: 24,),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: const Color.fromARGB(255,33,33,33),
                    ),
                    children: const [
                      TextSpan(
                          text: '     Пожалуйста, внимательно прочитайте эти правила, прежде чем начать пользоваться приложением NikahTime.\n\n'
                      ),
                      TextSpan(
                          text: '     Мы разработали их, чтобы напомнить себе и Вам о правилах приличия и морали, а также, чтобы создать атмосферу, которая способствует праведному общению между пользователями.\n'
                      ),
                      TextSpan(
                          text: '     NikahTime - площадка для людей с серьезными намерениями, которые мечтают создать семью, родить детей, жить по канонам ислама, духовных ценностей и национальных традиций. \n'
                      ),
                      TextSpan(
                          text: '     Нашей целью является то, чтобы каждый мусульманин(ка) по милости Аллаха зарегистрировался в приложении NikahTime и нашёл свою половинку, женился/вышла замуж, обрёл человеческое счастье, укрепляя институт семьи в исламе! \n'
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                Text(
                  'Справочная информация:',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color.fromARGB(255,33,33,33),
                  ),
                ),
                const SizedBox(height: 16,),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: const Color.fromARGB(255,33,33,33),
                    ),
                    children: const[
                      TextSpan(
                          text: '•	После регистрации заполните свой профиль и внесите необходимые данные о себе в анкету.\n'
                      ),
                      TextSpan(
                          text: '•	При изменении каких-либо данных вы всегда можете зайти в свой профиль и отредактировать их.\n'
                      ),
                      TextSpan(
                          text: '•	На фото профиля устанавливайте только своё фото. Выбирайте фотографию хорошего качества, где видно ваше лицо, в кадре нет посторонних лиц.\n'
                      ),
                      TextSpan(
                          text: '•	В настройках профиля вы можете ознакомиться с общими положениями приложения.\n'
                      ),
                      TextSpan(
                          text: '•	Если у Вас возникли трудности или вопросы, вы можете написать разработчикам. Для этого в настройках найдите раздел «Помощь» и отправьте свой вопрос.\n'
                      ),
                      TextSpan(
                          text: '•	Узнать больше о создателях приложения и специалистах, которые здесь работают Вы можете в разделе «О нас» в настройках приложения.\n'
                      ),
                      TextSpan(
                          text: '•	Бесплатный пробный период пользования приложением доступен в течение трёх суток после регистрации. Далее будет взиматься плата, согласно установленному тарифу.\n'
                      ),
                      TextSpan(
                          text: '•	Для дальнейшего пользования вы можете внести благотворительный взнос/милостыню (садака) – 799 руб/мес.\n'
                      ),
                      TextSpan(
                          text: '•	Тариф можно выбрать на 1, 3 или 6 месяцев. При этом, размер благотворительного взноса составит: 799; 1899 и 3499 соответственно. \n'
                      ),
                      TextSpan(
                          text: '•	Садака, которую вы будете вносить ни в каком случае не возвращается, и пойдет на развитие и модернизацию приложения NikahTime, а также, на формирование и накопление призового фонда. Накопленные в нём средства мы будем использовать на розыгрыши ценных призов для наших дорогих пользователей.\n'
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                Text(
                  'В общении друг с другом придерживайтесь следующих принципов:',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color.fromARGB(255,33,33,33),
                  ),
                ),
                const SizedBox(height: 16,),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: const Color.fromARGB(255,33,33,33),
                    ),
                    children: const [
                      TextSpan(
                          text: '•	Помните о главной цели своей регистрации и пользования приложением – создание мусульманской семьи.\n'
                      ),
                      TextSpan(
                          text: '•	Ведите себя уважительно ко всем пользователям и администраторам приложения.\n'
                      ),
                      TextSpan(
                          text: '•	Общайтесь с противоположным полом в рамках, допустимых законами религии.\n'
                      ),
                      TextSpan(
                          text: '•	В приложении NikahTime девушкам необходимо уведомить своего махрама об общении с противоположным полом.\n'
                      ),
                      TextSpan(
                          text: '•	Делайте дуа и просите Всевышнего помочь найти свою половинку.\n'
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                Text(
                  'Здесь запрещены:',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color.fromARGB(255,33,33,33),
                  ),
                ),
                const SizedBox(height: 16,),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: const Color.fromARGB(255,33,33,33),
                    ),
                    children: const [
                      TextSpan(
                          text: '•	Оскорбления и угрозы в адрес пользователей или администрации.\n'
                      ),
                      TextSpan(
                          text: '•	Высказывания, содержащие ненормативную лексику, унижающие человеческое достоинство, разжигающие межнациональную рознь.\n'
                      ),
                      TextSpan(
                          text: '•	Размещение фото и видео непристойного содержания.\n'
                      ),
                      TextSpan(
                          text: '•	Действия, противоречащие рамкам шариата.\n'
                      ),
                      TextSpan(
                          text: '•	Действия, которые порочат честь, достоинство, деловую репутацию других лиц. \n'
                      ),
                      TextSpan(
                          text: '•	Поиск пары для тайного или временного браков.\n'
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                Text(
                  'Предупреждаем вас:',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color.fromARGB(255,33,33,33),
                  ),
                ),
                const SizedBox(height: 16,),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: const Color.fromARGB(255,33,33,33),
                    ),
                    children: const[
                      TextSpan(
                          text: '•	Ответственность за передачу личных данных другим лицам, за результаты знакомств и дальнейшие последствия лежит на самом пользователе.\n'
                      ),
                      TextSpan(
                          text: '•	При обнаружении неприличного общения, необходимо сообщить администраторам, для принятия ими необходимых мер.\n'
                      ),
                      TextSpan(
                          text: '•	Администрация приложения оставляет за собой право удалять комментарии или часть комментариев, если они не соответствуют требованиям поведения и общения.\n'
                      ),
                      TextSpan(
                          text: '•	При несоблюдении норм этикета, нарушении данных правил пользования приложением, администраторы вправе заблокировать пользователя и разорвать соглашение в одностороннем порядке.\n'
                      ),
                      TextSpan(
                          text: '•	В  дальнейшем ему навсегда будет отказано в доступе к регистрации и пользованию приложением NikahTime. \n'
                      ),
                      TextSpan(
                          text: 'Благодарим Вас за понимание и за желание сделать пользование приложением и общение здесь в рамках законов Всевышнего.\n'
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                Text(
                  'Аллах сотворил человека из одной души и из неё же сотворил ей пару, с которой она успокаивается. (Коран, сура Аль-А’раф 7:189). ',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color.fromARGB(255,33,33,33),
                  ),
                ),
                const SizedBox(height: 16,),
                Text(
                  'Добро пожаловать в NikahTime!',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color.fromARGB(255,33,33,33),
                  ),
                ),
              ]
          )
      ),
    );
  }
}