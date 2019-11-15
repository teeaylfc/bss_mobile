import 'package:bss_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/util/image_util.dart';
import 'package:bss_mobile/src/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';

class CategoryCard extends StatelessWidget {
  final double width;
  final double height;
  final double imageHeight;
  final double paddingRight;
  final String displayType;

  final Category category;

  const CategoryCard({this.category, this.width, this.height, this.imageHeight, this.paddingRight, this.displayType});

  @override
  Widget build(BuildContext context) {
    final image = ImageUtil.getImageUrlFromList([category.imageDTO]);
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            bottomNavBarBloc.pickItem(
              PageIndex.COUPON_LIST,
              {'category': category, 'previousPage': 'CATEGORY'},
            );
          },
          child: FadeInWidget(
            duration: Config.FADEIN_DURATION,
            child: Container(
              padding: EdgeInsets.only(right: paddingRight),
              child: Container(
                margin: EdgeInsets.fromLTRB(3.0, 2, (displayType != null ? (displayType == 'GRID' ? 0 : 3) : 12 - paddingRight), 3),
                height: height,
                width: width,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.12).withOpacity(0.12), offset: new Offset(0.0, 0.0), blurRadius: 3.0, ),
                ], borderRadius: BorderRadius.circular(8.0), color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                      child: Image(
                        image: image,
                        width: width,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(5),
                          ),
                          child: Text(
                            category.categoryDescription,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
