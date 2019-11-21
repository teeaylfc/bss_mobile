import 'package:bss_mobile/src/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/util/internet_connectivity.dart';
import 'package:bss_mobile/src/models/address_model.dart';
import 'package:bss_mobile/src/models/store_model.dart';
import 'package:bss_mobile/src/pages/address_add.dart';
import 'package:bss_mobile/src/pages/grid_view_store.dart';
import 'package:bss_mobile/src/pages/page_state.dart';
import 'package:bss_mobile/src/pages/sign_in.dart';
import 'package:bss_mobile/src/pages/stadium_manager.dart';
import 'package:bss_mobile/src/pages/store_info.dart';
import 'package:bss_mobile/src/service/auth_service.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/address_card.dart';
import 'package:bss_mobile/src/widgets/bubble_tab_indicator.dart';
import 'package:bss_mobile/src/widgets/no_internet.dart';
import 'package:bss_mobile/src/widgets/raised_gradient_button.dart';
import 'package:bss_mobile/src/widgets/refresh_footer.dart';
import 'package:bss_mobile/src/widgets/refresh_header.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
import 'package:bss_mobile/src/widgets/store_card.dart';
import 'package:bss_mobile/src/widgets/tab_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:flutter/services.dart';

class StoreListPage extends StatefulWidget {
  const StoreListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StoreListPageState();
  }
}

class _StoreListPageState extends PageState<StoreListPage>{

  DataService dataService = DataService();
  RefreshController _refreshController = RefreshController();

  bool loading;

  String errorMessage;

  final List<Tab> tabs = <Tab>[
    Tab(text: "Tất cả cửa hàng"),
    Tab(text: "Cửa hàng yêu thích")
  ];
  double opacityHeader = 0;
  TabController _tabController;

  AuthService authService = AuthService();
  ApplicationBloc applicationBloc;
  AuthenticationState authStatus = AuthenticationState.notDetermined;
  List<Address> listAddress = List<Address>();

  @override
  void initState() {
    // TODO: implement initState
    getAllAddress();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _tabController.dispose();

    super.dispose();
  }


  getAllAddress(){
    print("000000000000000000");
     listAddress = [];
    dataService.getAllAdress().then((data){
      setState(() {
        listAddress.addAll(data.address);
      });

    }).catchError((error){
      print(error);
    });
  }

  void _onRefresh() async{
    // monitor network fetch
     await getAllAddress();
     await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        gradient: CommonColor.leftRightLinearGradient
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(child: Text("Quản lý địa điểm")),
        ),
       body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SmartRefresher(
            controller: _refreshController,
            onRefresh: (){
            _onRefresh();
            },

          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color(0xffF7F7F7),
            child: Column(
              children: <Widget>[
                      Expanded(
                     child: ListView.builder(
                       physics: NeverScrollableScrollPhysics(),
                    itemCount: listAddress.length,
                    itemBuilder: (context,index){
                        return _addressCard(listAddress[index]);
                    },
                  ),
                      )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(   
        color: Colors.white,   
      padding: const EdgeInsets.all(10.0),
      child: RaisedGradientButton(
          child: Text(
            'Thêm địa điểm',
            style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
          ),
          gradient: CommonColor.leftRightLinearGradient,
      height: ScreenUtil().setSp(40),
          onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AddressAddPage()
                  ));
          }),
        ),
      ),
    );
  }

  Widget _addressCard(Address address){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => StadiumManager()));
      },
      onLongPress: (){},
      child: Container(
              width: ScreenUtil().setWidth(345),
              constraints: BoxConstraints(minHeight: ScreenUtil().setSp(115)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                      offset: Offset(
                        1.0, // horizontal, move right 10
                        1.0, // vertical, move down 10
                      ),
                    )
                  ]),
              margin: EdgeInsets.only(
                top: ScreenUtil().setSp(15),
              ),
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(14),
                horizontal: ScreenUtil().setWidth(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset("assets/images/loyalty/stadium_logo.jpg",width: ScreenUtil().setSp(70),height: ScreenUtil().setSp(70),),
                  SizedBox(
                    width: ScreenUtil().setSp(15),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        address.name ?? 'Sân bóng',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.bold,
                          color: CommonColor.textBlack,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setSp(6),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: ScreenUtil().setWidth(230),
                          minHeight: ScreenUtil().setHeight(20),
                        ),
                        child: Text(
                          address.description ?? '',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.bold,
                            color: Color(0xff696969),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setSp(10),
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset("assets/images/loyalty/location_icon.png",width: 20,height: 25,),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                         constraints: BoxConstraints(
                          maxWidth: ScreenUtil().setWidth(200),
                          minHeight: ScreenUtil().setHeight(18),
                        ),
                            child: Text(
                              address.specificAddress+', ' +  address.town.name + ', ' + address.district.name + ', ' + address.city.name,
                              style: TextStyle(
                                  color: Color(0xffFD4435),
                                  fontSize: ScreenUtil().setSp(12),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                         Container(child: Image.asset("assets/images/loyalty/edit_icon.png",width: ScreenUtil().setSp(25),height: ScreenUtil().setSp(25),)),
                         SizedBox(
                           width: ScreenUtil().setSp(20),
                         ),
                          GestureDetector(
                            onTap: () async{
                              await _asyncConfirmDialog(context, address.id);
                            },
                            child: Container(child: Image.asset("assets/images/loyalty/delete_icon.png",width: ScreenUtil().setSp(25),height: ScreenUtil().setSp(25),))),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }

     Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, id) async {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: ConfirmDialog(
                  width: 306,
                  height: 263,
                  image: 'assets/images/remove_icon.png',
                  title: "Bạn có chắc muốn xóa địa điểm này?",
                  callbackConfirm: () async{
                    try{
                     await  dataService.deleteAddress(id);
                     getAllAddress();
                    }catch(error){
                      Reusable.showTotastError(error.toString());
                    }
                  },
                )),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

//  _buildListStore() {
//    return SliverPadding(
//      padding: EdgeInsets.only(
//          left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15)),
//      sliver: SliverList(
//        delegate: SliverChildBuilderDelegate(
//          (context, index) {
//            var store = listStore[index];
//            return Container(
//              padding: EdgeInsets.only(top: 19),
//              child: StoreCard(
//                store: store,
//              ),
//            );
//          },
//          childCount: listStore.length,
//        ),
//      ),
//    );
//  }

  @override
  bool get wantKeepAlive => true;

  @override
  Future initData() {
    // TODO: implement initData
    return null;
  }

  @override
  Future loadMoreData() {
    // TODO: implement loadMoreData
    return null;
  }

  @override
  Future refreshData() {
    // TODO: implement refreshData
    return null;
  }


}
