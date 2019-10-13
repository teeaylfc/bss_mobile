import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

// ignore: must_be_immutable
class ItemSupport extends StatefulWidget {
  final String title;
  final Function onPress;
  final String expand;

  ItemSupport({this.title, this.onPress, this.expand});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ItemSupportState();
  }
}

class ItemSupportState extends State<ItemSupport> {
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return GestureDetector(
      onTap: widget.expand != null
          ? () => _changeVisibleAnswer()
          : widget.onPress != null ? () => widget.onPress() : null,
      child: Container(
        width: width,
        margin: EdgeInsets.only(
          top: ScreenUtil().setSp(15),
          left: ScreenUtil().setSp(15),
          right: ScreenUtil().setSp(15),
        ),
        padding: EdgeInsets.only(
          left: ScreenUtil().setSp(14),
          top: ScreenUtil().setSp(20),
          bottom: ScreenUtil().setSp(20),
          right: ScreenUtil().setSp(10),
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 0),
              )
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                      color: Color(0xFF343434),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                showAnswer
                    ? Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setSp(5)),
                        child: Html(
                          data: widget.expand,
                        ))
                    : Container(),
              ],
            )),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setSp(10)),
              alignment: Alignment.bottomCenter,
              child: Icon(
                showAnswer
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_right,
                color: Color(0xff0A4DD0),
                size: ScreenUtil().setSp(17),
              ),
            )
          ],
        ),
      ),
    );
  }

  _changeVisibleAnswer() {
    print("show answer");
    setState(() {
      showAnswer = !showAnswer;
    });
  }
}
