import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/models/store_model.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';

class GridViewStore extends StatefulWidget{
  final String type;
  GridViewStore({this.type});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GridViewStoreState();
  }

}
class GridViewStoreState extends State<GridViewStore>{
  DataService dataService = new DataService();
  List<Store> listStore = List<Store>();
  ApplicationBloc applicationBloc;
  int page= 0;
  var last;
  @override
  void initState() {
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    getStoreList();
    // TODO: implement initState
    super.initState();
  }
  getStoreList() {
    dataService.getStore(page, widget.type == TypeStore.FAVORITE_STORE ? true : false).then((data) {
      print("data: ${data.content}");
      setState(() {
        if (page == 0) {
          listStore = [];
        }
        listStore.addAll(data.content);
//        last = data.last;
      });
    }).catchError((error) {
      Reusable.handleHttpError(context, error, applicationBloc);
    });
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print("all store");
    // TODO: implement build
    return Container(
      color: Colors.green,
      width: width,
      child: Column(
        children: <Widget>[
          Text('1245')
        ],
      ),
    );
  }
}