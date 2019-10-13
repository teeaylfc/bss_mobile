import 'package:ols_mobile/main.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class DistributorPage extends StatefulWidget {
  DistributorPage() {}

  @override
  State<StatefulWidget> createState() {
    return _DistributorPageState();
  }
}

class _DistributorPageState extends State<DistributorPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List buttons = [
    {'text': 'REWARDS', 'image': 'distributor_ic1'},
    {'text': 'PRIVILEGES', 'image': 'distributor_ic2'},
    {'text': 'INFORMATION', 'image': 'distributor_ic3'},
    {'text': 'CARD BENEFITS', 'image': 'distributor_ic4'},
    {'text': 'COUPONYOU WANT', 'image': 'distributor_ic5'},
    {'text': 'BANKING SERVICES', 'image': 'distributor_ic6'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.hardLight),
              image: AssetImage('assets/images/distributor_bg.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildLogo(),
              _buildText(),
              _buidLogin(),
              _buildGrid(),
            ],
          ),
        ),
      ),
    );
  }

  _buildLogo() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      width: MediaQuery.of(context).size.width / 1.2,
      height: ScreenUtil().setSp(100),
      color: Color(0xFFFFBB00),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: ScreenUtil().setSp(20),
          ),
          Image(
            height: ScreenUtil().setSp(60),
            image: AssetImage(
              'assets/images/distributor_logo.png',
            ),
          ),
          SizedBox(
            width: ScreenUtil().setSp(10),
          ),
          Text(
            'Maybank',
            style: TextStyle(fontSize: ScreenUtil().setSp(50), color: Colors.black, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  _buildText() {
    return Container(
        padding: EdgeInsets.only(top: 30, left: 20),
        child: Text(
          'MAYBANK \nTREATS SG',
          style: TextStyle(fontSize: ScreenUtil().setSp(30), color: Color(0xFFFFC700), fontWeight: FontWeight.bold),
        ));
  }

  _buidLogin() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 15),
      child: Container(
          width: ScreenUtil().setSp(100),
          height: ScreenUtil().setSp(30),
          decoration: BoxDecoration(
            color: Color(0xFFFEC601),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w500),
            ),
          )),
    );
  }

  _buildGridIcon(index) {
    return Material(
      color: Color(0xFFFEC601),
      child: InkWell(
        onTap: () {
          if (index == 4) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SplashPage()));
          }
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(
                buttons[index]['text'],
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: ScreenUtil().setSp(8),
              ),
              Image(
                height: ScreenUtil().setSp(55),
                image: AssetImage(
                  'assets/images/' + buttons[index]['image'] + '.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildGrid() {
    return Container(
        padding: EdgeInsets.only(top: 50),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: GridView.count(
            mainAxisSpacing: 6.0,
            crossAxisSpacing: 6,
            crossAxisCount: 3,
            padding: EdgeInsets.all(20.0),
            children: new List<Widget>.generate(6, (index) {
              return _buildGridIcon(index);
            })));
  }
}
