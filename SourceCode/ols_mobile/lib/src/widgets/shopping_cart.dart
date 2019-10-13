import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:ols_mobile/src/pages/cart_page.dart';

class ShoppingCart extends StatelessWidget {

  const ShoppingCart();

  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    return StreamBuilder<int>(
        stream: applicationBloc.orderCountStream,
        builder: (context, snapshot) {
          return Badge(
            showBadge: snapshot.hasData && snapshot.data > 0,
            badgeColor: Color(0xFF0A4DD0),
            position: BadgePosition.topLeft(),
            borderRadius: 12,
            padding: EdgeInsets.all(3),
            badgeContent: Text(
              snapshot.data.toString(),
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(8), fontWeight: FontWeight.bold),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return CartPage();
                      },
                      fullscreenDialog: true),
                );
              },
              child: Image.asset(
                'assets/images/loyalty/shopping_cart.png',
                width: ScreenUtil().setSp(24),
                height: ScreenUtil().setSp(24),
              ),
            ),
          );
        });
  }
}
