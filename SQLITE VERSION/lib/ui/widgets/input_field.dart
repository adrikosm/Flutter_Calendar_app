import 'package:flutter/material.dart';
import 'package:task_1/ui/theme.dart';
import 'package:task_1/utils/colors_util.dart';

// ignore: must_be_immutable
class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  TextEditingController controller = TextEditingController();
  final Widget widget;
  final bool whiteText;
  final bool fullSize;
  final bool isPassword;
  final bool isEmail;

  final bool selectedHintColor;
  final String hintColor;
  MyInputField(
      {Key key,
      this.title,
      this.hint,
      this.controller,
      this.widget,
      this.selectedHintColor = false,
      this.hintColor,
      this.whiteText = false,
      this.fullSize = true,
      this.isPassword = false,
      this.isEmail = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          whiteText == true
              ? Text(title, style: taskTitleWhite)
              : Text(
                  title,
                  style: taskTitle.copyWith(color: Colors.black),
                ),
          Container(
            height: 50,
            width: fullSize
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.only(top: 10, left: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: whiteText == true ? Colors.white : Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(children: [
              Expanded(
                child: TextFormField(
                  keyboardType: isEmail == true
                      ? TextInputType.emailAddress
                      : TextInputType.text,
                  obscureText: isPassword == true ? true : false,
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  cursorColor: whiteText == true ? Colors.white : Colors.grey,
                  controller: controller,
                  style: whiteText == true
                      ? basicTextStyle.copyWith(color: Colors.white)
                      : basicTextStyle.copyWith(color: Colors.black),
                  decoration:
                      // Check whether the hint color is selected
                      // If it is selected set the hint color to
                      // user selected color
                      selectedHintColor == true
                          ? InputDecoration(
                              hintText: hint,
                              hintStyle: basicTextStyle.copyWith(
                                  color: HexColor(hintColor)),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0),
                              ),
                            )
                          :
                          // If not selected, use the default hint color
                          InputDecoration(
                              hintText: hint,
                              hintStyle: whiteText == true
                                  ? taskBasicStyle.copyWith(color: Colors.white)
                                  : taskBasicStyle.copyWith(
                                      color: Colors.black),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0),
                              ),
                            ),
                ),
              ),

              // Print out Widget if available
              widget == null
                  ? Container()
                  : Container(
                      child: widget,
                    ),
            ]),
          ),
        ],
      ),
    );
  }
}
