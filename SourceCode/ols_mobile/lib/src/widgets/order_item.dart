import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderItemState();
  }

  final int index;
  final item;
  final changeAmount;
  final storage = const FlutterSecureStorage();

  const OrderItem({this.item, this.index, this.changeAmount});
}

class OrderItemState extends State<OrderItem> {
  int count;

  @override
  void initState() {
    setState(() {
      count = widget.item.quantity;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var itemImage = widget.item.imageDTO[0];
    var endDateFM = DateFormat('dd/MM/yyyy').format(widget.item.endDate);
    // TODO: implement build
    return count > 0
        ? Stack(
            children: <Widget>[
              Opacity(
                  opacity: widget.item.expired ? 0.5 : 1,
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(ScreenUtil().setSp(12), 0, 0, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setSp(10), 10, 10, 10),
                      height: ScreenUtil().setSp(121),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.only(top: ScreenUtil().setSp(38)),
                              child: Image.network(
//                            'assets/images/loyalty/demo2.png',
                                itemImage.imagePath,
                                width: ScreenUtil().setSp(58),
                                height: ScreenUtil().setSp(58),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setSp(13),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Giảm 200.000VND cho hoá đơn trên 1.000.000VND',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(14),
                                        color: CommonColor.textBlack),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setSp(9),
                                  ),
                                  Text(
                                    widget.item.itemName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(14),
                                        color: CommonColor.textGrey),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setSp(9),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Image(
                                        height: ScreenUtil().setSp(18),
                                        image: AssetImage(
                                            'assets/images/loyalty/m_dollar.png'),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setSp(9),
                                      ),
                                      Text(
                                        widget.item.itemPrice.toString(),
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(14),
                                          fontWeight: FontWeight.bold,
                                          color: (CommonColor.textGrey),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: ScreenUtil().setSp(24),
                                        width: ScreenUtil().setSp(24),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setSp(24),
                                              child: FloatingActionButton(
                                                heroTag: "btnMinus" +
                                                    widget.index.toString(),
                                                shape: CircleBorder(
                                                    side: BorderSide(
                                                        color:
                                                            Color(0xffE7E7E7),
                                                        width: 1.0)),
                                                elevation: 0,
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.black,
                                                  size: 16,
                                                ),
                                                onPressed: widget.item.expired
                                                    ? null
                                                    : () => _onMinus(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setSp(14),
                                            ),
                                            Text(
                                              count.toString(),
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                fontWeight: FontWeight.bold,
                                                color: (CommonColor.textBlack),
                                              ),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setSp(14),
                                            ),
                                            Container(
                                              width: ScreenUtil().setSp(24),
                                              child: FloatingActionButton(
                                                heroTag: "btnAdd" +
                                                    widget.index.toString(),
                                                shape: CircleBorder(
                                                    side: BorderSide(
                                                        color:
                                                            Color(0xffE7E7E7),
                                                        width: 1.0)),
                                                elevation: 0,
                                                backgroundColor: Colors.white,
                                                onPressed: widget.item.expired
                                                    ? null
                                                    : () => _onPlus(),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.black,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
              Positioned(
                top: ScreenUtil().setSp(12),
                left: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color:
                          Color(widget.item.expired ? 0xFfEB5757 : 0xFFE7E7E7),
                      width: ScreenUtil().setSp(70),
                      height: ScreenUtil().setSp(18),
                      child: Center(
                        child: Text(
                          endDateFM,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: widget.item.expired
                                  ? Colors.white
                                  : Color(0xFF696969)),
                        ),
                      ),
                    ),
                    ClipPath(
                      child: Container(
                        height: ScreenUtil().setSp(5),
                        width: ScreenUtil().setSp(5),
                        color: Color(
                            widget.item.expired ? 0xFf9C3030 : 0xFFC7C7C7),
                      ),
                      clipper: TriangleClipper(),
                    )
                  ],
                ),
              )
            ],
          )
        : Container();
  }

  _onPlus() {
    setState(() {
      count = count + 1;
    });
    widget.item.quantity = count;
    widget.changeAmount(widget.item, ChangeAmount.PLUS);
  }

  _onMinus() {
    setState(() {
      count = count - 1;
    });
    widget.item.quantity = count;
    widget.changeAmount(widget.item, ChangeAmount.MINUS);
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
