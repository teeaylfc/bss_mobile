import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/util/image_util.dart';
import 'package:flutter/material.dart';

class MerchantImage extends StatelessWidget {
  final int imageId;
  final double width;
  final double height;
  final double radius;
  const MerchantImage({this.imageId,this.width = 60 , this.height = 60, this.radius = 18});

  @override
  Widget build(BuildContext context) {
//    final image = ImageUtil.getImage(imageId) ;
    final image = AssetImage("assets/images/loyalty/demo2.png");

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFECECEC), width: 1),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        image: DecorationImage(fit: BoxFit.fill, image: image),
      ),
    );
  }
}


