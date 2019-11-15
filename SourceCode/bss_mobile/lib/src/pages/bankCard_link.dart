import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/pages/choose_bank.dart';
import 'package:bss_mobile/src/pages/detail_card_link.dart';
import 'package:bss_mobile/src/widgets/header.dart';
import 'package:bss_mobile/src/widgets/showToast.dart';

class BankCardLink extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BankCardLinkContent();
  }
}

class BankCardLinkContent extends State<BankCardLink> {
//  MyBloc bloc = new MyBloc();
  var data;
  ApplicationBloc applicationBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(
      title: FlutterI18n.translate(context, "profilePage.cardLinked"),
      body: content(context),
    );
  }

  void initState() {
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    super.initState();
  }

  Widget content(context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: double.infinity,
      color: Colors.grey[100],
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bg_bank.png',
              fit: BoxFit.contain,
              width: width * 0.77,
              height: width * 0.7,
            ),
          ),
          Column(
            children: <Widget>[
              StreamBuilder(
                  stream: applicationBloc.listBankcardStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0) {
//                      Toast(context: context, title: 'Tặng điểm thành công').showToast();
                      return _renderListBank(snapshot.data);
                    }
                    return Container(
                      width: width,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 17),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[300],
                                offset: Offset(0, 0),
                                blurRadius: 3,
                                spreadRadius: 1)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            FlutterI18n.translate(
                                context, "cardLinked.associateWithTheBank"),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            child: Text(
                                FlutterI18n.translate(context,
                                    "cardLinked.associateWithTheBankForEasy"),
                                style: TextStyle(fontSize: 14)),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                child: Text(
                                  FlutterI18n.translate(
                                      context, "cardLinked.linkNow"),
                                  style: TextStyle(
                                      color: Color(0xFF0A4DD0),
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () => _onLink(),
                              ),
                              Image.asset(
                                'assets/images/ic_doubleCard.png',
                                width: 73,
                                height: 47,
                                fit: BoxFit.contain,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ],
          )
        ],
      ),
    );
  }

  Widget _renderListBank(data) {
    print('dataa:  ${data.length}');
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                _renderItem(data[index]),
                GestureDetector(
                  onTap: () => _onLink(),
                  child: Container(
                    width: width,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: EdgeInsets.only(
                        left: 20, right: 12, top: 17, bottom: 17),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(0, 0),
                              blurRadius: 3,
                              spreadRadius: 1)
                        ]),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setSp(10)),
                          child: Image.asset(
                            'assets/images/ic_addnewCard.png',
                            width: ScreenUtil().setSp(40),
                            height: ScreenUtil().setSp(40),
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text( FlutterI18n.translate(
                            context, "cardLinked.addNewCard"))
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget _renderItem(item) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => _infoCard(),
      child: Container(
          width: width,
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          padding: EdgeInsets.only(left: 20, right: 12, top: 17, bottom: 17),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(0, 0),
                    blurRadius: 3,
                    spreadRadius: 1)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      item['image'],
                      width: ScreenUtil().setSp(50),
                      height: ScreenUtil().setSp(50),
                      fit: BoxFit.contain,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          item['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setSp(22),
                            right: ScreenUtil().setSp(15)),
                      ),
                    )
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF696969),
              )
            ],
          )),
    );
  }

  _infoCard() {
    var route = new MaterialPageRoute(builder: (context) => DetailCardLink());
    Navigator.push(context, route);
  }

  _onLink() {
    var route = new MaterialPageRoute(builder: (context) => ChooseBank());
    Navigator.push(context, route);
  }
}
