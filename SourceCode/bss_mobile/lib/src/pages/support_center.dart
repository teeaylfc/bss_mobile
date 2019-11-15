import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/pages/about_mbf.dart';
import 'package:bss_mobile/src/pages/ask_question.dart';
import 'package:bss_mobile/src/pages/send_feedback.dart';
import 'package:bss_mobile/src/pages/term_condition.dart';
import 'package:bss_mobile/src/widgets/header.dart';
import 'package:bss_mobile/src/widgets/item_support.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
import 'package:bss_mobile/src/widgets/showToast.dart';

class SupportCenter extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SupportCenterState();
  }

}
class SupportCenterState extends State<SupportCenter>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(title: FlutterI18n.translate(context, 'profilePage.support'), body: content(context),);
  }
  Widget content(context){
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setSp(5),
        bottom: ScreenUtil().setSp(5),
      ),
      width: width,
      alignment: Alignment.center,
      color: Colors.grey[100],
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              ItemSupport(title: FlutterI18n.translate(context, 'supportCenter.aboutMbf'),onPress: () => navigateScreens(AboutMbf(), context) ),
              ItemSupport(title: FlutterI18n.translate(context, 'supportCenter.tac'), onPress: () => navigateScreens(TermCondition(), context)),
              ItemSupport(title: FlutterI18n.translate(context, 'supportCenter.faq'),  onPress: () => navigateScreens(AskQuestion(), context)),
              ItemSupport(title: FlutterI18n.translate(context, 'supportCenter.sendFeedback'),onPress: () => navigateScreens(SendFeedBack(), context)),
            ],
          ),
        ],
      ),
    );
  }
  navigateScreens(screens, context) async{
    var route = new MaterialPageRoute(builder: (context)=> screens);
    var success = await Navigator.push(context, route);
    print(success);
    if(success){
      Reusable.showMessageDialog(success, 'Gửi phản hồi thành công', context);
    }
  }
}