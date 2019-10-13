import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/models/item_cms_model.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/widgets/header.dart';
import 'package:ols_mobile/src/widgets/item_support.dart';

class TermCondition extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TermConditionState();
  }
}
class TermConditionState extends State<TermCondition>{
  ApplicationBloc applicationBloc;
  String _currentLanguage;
  DataService dataService = DataService();
  List<Content> listTac = [];
  @override
  void initState() {
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    _currentLanguage = applicationBloc.currentLanguageValue.value;
    getCmsTac();
    // TODO: implement initState
    super.initState();
  }
  getCmsTac(){
    dataService.getCmsTac(_currentLanguage, 0).then((data) {
      setState(() {
        if (data.content != null) {
          listTac = data.content;
        }
      });
    }).catchError((err) {});
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(title: FlutterI18n.translate(context, 'supportCenter.tac'),body: content(context),);
  }
  Widget content(context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setSp(5),
        bottom: ScreenUtil().setSp(5),
      ),
      width: width,
      color: Colors.grey[100],
      child: listTac.length > 0
          ? ListView.builder(
          itemCount: listTac.length,
          itemBuilder: (context, index) => ItemSupport(title: listTac[index].description, expand: listTac[index].longDescription,))
          : Container(),
    );
  }
}