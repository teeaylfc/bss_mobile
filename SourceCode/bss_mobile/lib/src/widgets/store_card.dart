import 'package:flutter/material.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/models/store_model.dart';
import 'package:bss_mobile/src/pages/store_info.dart';
import 'package:bss_mobile/src/style/color.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  const StoreCard({this.store});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return StoreInfoPage(storeId: store.storeId,);
              },
              fullscreenDialog: true),
        );
      },
      child: Container(
           decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Color(0xFFE7E7E7), width: 0.5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE7E7E7),
              blurRadius: 2,
              offset: new Offset(0.0, 0.2),
            )
          ],
        ),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            store.logoUrl != null
                ? Image.network(
                    store.logoUrl,
                    width: ScreenUtil().setSp(58),
                    height: ScreenUtil().setSp(58),
                  )
                : Image.asset(
                    'assets/images/no-image.jpg',
                    width: ScreenUtil().setSp(58),
                    height: ScreenUtil().setSp(58),
                  ),
            SizedBox(
              width: ScreenUtil().setSp(9),
            ),
            Text(
              store.storeName,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.bold,
                color: (CommonColor.textGrey),
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: ScreenUtil().setSp(8),
              color: Color(0xFF0A4DD0),
            )
          ],
        ),
      ),
    );
  }
}
