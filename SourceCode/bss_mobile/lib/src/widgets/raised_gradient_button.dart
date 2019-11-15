import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final bool imageLeading;
  final Widget child;
  final AssetImage image;
  final double imageWidth;
  final double imageHeight;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;
  final Color color;
  final Icon icon;
  final bool enable;
  final double borderRadius;

  final Color borderColor;

  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.imageLeading,
    this.gradient,
    this.width = double.infinity,
    this.enable = true,
    this.height = 50.0,
    this.image,
    this.imageWidth = 18,
    this.imageHeight = 21,
    this.icon,
    this.color,
    this.borderColor,
    this.borderRadius = 20,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttonContent = [child];
    if (image != null) {
      if (image != null) {
        buttonContent = [
          Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              image: DecorationImage(image: image),
            ),
          ),
          SizedBox(
            width: imageLeading == null || imageLeading == false ? ScreenUtil().setSp(10) :  ScreenUtil().setSp(42),
          ),
          imageLeading == null || imageLeading == false
              ? child
              : Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setSp(56)) ,
            child: child,
          )
        ];
      } else if (icon != null) {
        buttonContent = [icon, SizedBox(width: ScreenUtil().setSp(10)), child];
      }
    }
    var decoration = BoxDecoration();
    if (enable) {
      if (gradient != null) {
        decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor != null ? borderColor : Colors.transparent,
            width: 1,
          ),
          gradient: gradient,
        );
      } else if (color != null) {
        decoration = BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor != null ? borderColor : Colors.transparent,
            width: 1,
          ),
        );
      }
    } else {
      decoration = BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.grey),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white30,
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttonContent,
          ),
        ),
      ),
    );
  }
}
