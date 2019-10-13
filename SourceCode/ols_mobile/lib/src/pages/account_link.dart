import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/add_account_link.dart';
import 'package:ols_mobile/src/widgets/header.dart';

class AccountLink extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AccountLinkState();
  }
}

class AccountLinkState extends State<AccountLink> {
  List data = [
    {
      "id": "1",
      "name": "Vietnam Airlines",
      "image": "assets/images/ic_vnairlines.png",
    },
    {
      "id": "2",
      "name": "Vietjet Air",
      "image": "assets/images/ic_vnairlines.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(
      title: FlutterI18n.translate(context, 'accountLinked.header'),
      body: content(context),
      btnRight: addAccount,
    );
  }

  addAccount() {
    var route = new MaterialPageRoute(builder: (context)=> AddAccountLink());
    Navigator.push(context, route);
  }

  Widget content(context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
        width: width,
        color: Colors.grey[100],
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => _renderItem(data[index], index)));
  }

  _renderItem(item, index) {
    print(item);
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: EdgeInsets.only(
        top: index == 0 ? ScreenUtil().setHeight(20) : 0,
        bottom: ScreenUtil().setHeight(15),
        left: ScreenUtil().setWidth(15),
        right: ScreenUtil().setWidth(15),
      ),
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(17),
        bottom: ScreenUtil().setHeight(17),
        left: ScreenUtil().setWidth(10),
        right: ScreenUtil().setWidth(10),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(8)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 0))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Image.asset(
                  item['image'],
                  width: ScreenUtil().setWidth(32),
                  height: ScreenUtil().setWidth(32),
                  fit: BoxFit.contain,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    child: Text(
                      item['name'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                )

              ],
            ),
          ),
          Container(
            child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(10),
                    left: ScreenUtil().setWidth(15),
                    bottom: ScreenUtil().setWidth(10),
                  ),
                    child: Text(FlutterI18n.translate(context, 'accountLinked.unLink'),
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFFFD4435))))),
          )
        ],
      ),
    );
  }
}
