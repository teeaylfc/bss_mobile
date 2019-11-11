import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ols_mobile/src/style/color.dart';

class AddressAddPage2 extends StatefulWidget{
  String name;
  String cityId;
  String districtId;
  String communeId;
  String address;
  String description;
  
  AddressAddPage2({this.name,this.cityId,this.districtId,this.communeId,this.address,this.description});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdddressAddPage2State();
  }

}
class _AdddressAddPage2State extends State<AddressAddPage2>{
  int numberStadium = 4;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        gradient: CommonColor.leftRightLinearGradient
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text("Thêm sân"),
          automaticallyImplyLeading: true,
        ),
        body: Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: numberStadium,
            itemBuilder: (context,index){
              return _buildAddStadiumCard();
            },
          ),
        ),
      ),
    );
  }
  _buildAddStadiumCard(){
    return Container();
  }
}