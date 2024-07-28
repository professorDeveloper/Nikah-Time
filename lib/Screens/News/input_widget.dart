

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/generated/locale_keys.g.dart';

Widget inputText(BuildContext context,{
  required bool show,
  required Function onFocusChange,
  required FocusNode focusNode,
  required Function onSubmitAction,
  required TextEditingController textEditingController
})
{
  return AnimatedSize(
    duration: Duration(milliseconds: 10),
    child: Align(
      alignment: Alignment.bottomCenter,
      child: show ? Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(
                0.0,
                -5.0,
              ),
              blurRadius: 2.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Focus(
                  onFocusChange: (value) => onFocusChange(value),
                  child: TextField(
                    focusNode: focusNode,
                    maxLines: 10,
                    minLines: 1,
                    maxLength: 255,
                    controller: textEditingController,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1,
                    ),
                    decoration: CustomInputDecoration(
                        hintText: LocaleKeys.news_addComment.tr(),
                        Icon: GestureDetector(
                          onTap: () => onSubmitAction(),
                          child: const Icon(
                            Icons.send,
                            size: 20,
                            color: Color.fromARGB(255, 117, 116, 115),
                          ),
                        )
                    ).GetDecoration(),
                  ),
                ),
              ),
            ],
          ),
        )
      ) : null,
    ),
  );
}