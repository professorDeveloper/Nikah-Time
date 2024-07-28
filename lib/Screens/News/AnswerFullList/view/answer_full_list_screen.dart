part of '../answer_full_list.dart';


class CommentaryAnswers extends StatefulWidget {
  CommentaryAnswers({
    required this.itemID,
    required this.newsId,
    required this.preloadItems,
    required this.headerItem
  });

  final int itemID;
  final int newsId;
  final List<CommentaryItem> preloadItems;
  final CommentaryItem headerItem;

  @override
  State<CommentaryAnswers> createState() => CommentaryAnswersState();
}

class CommentaryAnswersState extends State<CommentaryAnswers> {
  TextEditingController _textEditingController = TextEditingController();

  late FocusNode myFocusNode;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnswerFullListBloc>(
      create: (context) => AnswerFullListBloc(
        items: widget.preloadItems
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: BackNavigateAppBar(context),
        body: SafeArea(
          child: BlocBuilder<AnswerFullListBloc, AnswerFullListState>(
            builder: (BuildContext context, state) {
              state as AnswerFullListInitial;

              if(state.answerState == CommentariesState.preload)
              {
                context.read<AnswerFullListBloc>().add(LoadAnswers(id: widget.itemID));
                return answersWaitBox();
              }

              return bodyWidget(context, state);
            },
          ),
        ),
      ),
    );
  }


  Widget bodyWidget(BuildContext context, AnswerFullListInitial state) {
    return Stack(
      children: [
        CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  LocaleKeys.news_commentReply.tr(),//"Ответы к комментарию",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    //height: 1.4,
                    color: Colors.black,
                  ),
                ),
              )
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  commentaryItem(
                    context: context,
                    item: CommentaryFullItem(
                      commentary: widget.headerItem
                    ),
                    onTapAction: (){
                      _textEditingController.text = (widget.headerItem.user!.name ?? "") + ", ";
                      myFocusNode.requestFocus();
                    }
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            "assets/icons/pattern.png",
                            repeat: ImageRepeat.repeat,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            messagesStub(context, state),
            SliverToBoxAdapter(
              child: ( state.answerState != CommentariesState.noMoreItem) ? Center(child: CircularProgressIndicator()) : null,
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 90
              ),
            ),
          ],
        ),
        inputText( context,
          show: true,
          onFocusChange: (value){
            if(value == false){
              setState(() {
                _textEditingController.text = "";
              });
            }
          },
          focusNode: myFocusNode,
          onSubmitAction: (){
            context.read<AnswerFullListBloc>().add(
              AddAnswer(
                newsId: widget.newsId, text: _textEditingController.text, commentId: widget.itemID
              )
            );
            setState(() {
              _textEditingController.text = "";
            });
            myFocusNode.unfocus();
          },
          textEditingController: _textEditingController
        )
      ],
    );
  }

  Widget messagesStub(BuildContext context, AnswerFullListInitial state)
  {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: commentaryItem(
              context: context,
              size: 30,
              item: CommentaryFullItem(
                commentary: state.itemList[index],
              ),
              onTapAction: (){
                _textEditingController.text = (state.itemList[index].user!.name ?? "") + ", ";
                myFocusNode.requestFocus();
              }
            ),
          );
        },
        childCount: state.itemList.length,
      ),
    );

  }

}
