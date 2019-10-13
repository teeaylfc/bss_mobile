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
//import 'package:flutter_html_view/flutter_html_view.dart';
class AboutMbf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AboutMbfState();
  }
}

class AboutMbfState extends State<AboutMbf> {
  DataService dataService = DataService();
  List<Content> listFaq = [];
  ApplicationBloc applicationBloc;
  String _currentLanguage;
  @override
  void initState() {
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    _currentLanguage = applicationBloc.currentLanguageValue.value;
    getCmsFaq();
    // TODO: implement initState
    super.initState();
  }

  getCmsFaq() {
    dataService.getCmsAboutMbf(_currentLanguage, 0).then((data) {
      print("respone: ${data.content.length}");
      setState(() {
        if (data.content != null) {
          listFaq = data.content;
        }
      });
    }).catchError((err) {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(
      title: FlutterI18n.translate(context, "supportCenter.aboutMbf"),
      body: content(context),
    );
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
      child: listFaq.length > 0
          ? ListView.builder(
          itemCount: listFaq.length,
          itemBuilder: (context, index) => ItemSupport(title: listFaq[index].description, expand: listFaq[index].longDescription,))
          : Container(),
    );
  }
}
