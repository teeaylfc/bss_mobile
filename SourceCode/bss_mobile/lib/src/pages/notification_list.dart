import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/util/date_time_util.dart';
import 'package:bss_mobile/src/models/notification_model.dart';
import 'package:bss_mobile/src/pages/page_state.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/refresh_footer.dart';
import 'package:bss_mobile/src/widgets/refresh_header.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';

class NotificationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NotificationListState();
  }
}

class NotificationListState extends PageState<NotificationList> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  DataService dataService = DataService();
  List<MobileNotification> notificationList = List<MobileNotification>();
  ApplicationBloc applicationBloc;

  @override
  void initState() {
    super.initState();
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Container(
          padding: EdgeInsets.only(right: 36),
          child: Center(
              child: Text(
                FlutterI18n.translate(context, 'notificationPage.noti'),
            style: TextStyle(color: Colors.black),
          )),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          notificationList != null && notificationList.length > 0
              ? IconButton(
                  icon: Image.asset(
                    "assets/images/trash.png",
                    width: ScreenUtil().setSp(18),
                    height: ScreenUtil().setSp(20),
                  ),
                  onPressed: () {
                    _asyncConfirmDeleteNotificationDialog(context, null, true);
                  })
              : Container()
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
        child: _buildListNotification(),
      ),
    );
  }

  Widget _buildListNotification() {
    return EasyRefresh(
      autoLoad: false,
      key: _easyRefreshKey,
      refreshHeader: CustomRefreshHeader(
        color: CommonColor.backgroundColor,
        key: _headerKey,
      ),
      refreshFooter: CustomRefreshFooter(
        key: _footerKey,
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          notificationList != null && notificationList.length > 0
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var item = notificationList[index];
                      return _buildNotificationRow(item);
                    },
                    childCount: notificationList.length,
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(
                      child: Text(
                        FlutterI18n.translate(context, 'notificationPage.noNoti'),
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          color: CommonColor.textBlack,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
      onRefresh: () async {
        refreshData();
      },
      loadMore: () async {
        loadMoreData();
      },
    );
  }

  Widget _buildNotificationRow(MobileNotification notification) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 15),
          child: Container(
            width: ScreenUtil().setSp(345),
            constraints: BoxConstraints(
              minHeight: ScreenUtil().setSp(90),
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
            child: Slidable(
              closeOnScroll: true,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setSp(12),
                    ),
                    Text(
                      notification.messageTitle ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500, color: CommonColor.textBlack),
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(8),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          notification.messageContent,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(10),
                            color: CommonColor.textGrey,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            DateTimeUtil.timeAgoSinceDate(notification.receivedDateTime, numericDates: false),
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(10),
                              color: CommonColor.textGrey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setSp(8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Remove',
                  color: Color(0xFFEB5757),
                  icon: Icons.delete,
                  onTap: () {
                    _asyncConfirmDeleteNotificationDialog(context, notification.messageId, false);
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: notification.readInd == NotificationStatus.Y
              ? Container(
                  width: ScreenUtil().setSp(11),
                  height: ScreenUtil().setSp(11),
                  decoration: new BoxDecoration(
                    color: Color(0xFFFD4435),
                    shape: BoxShape.circle,
                  ),
                )
              : Container(),
        )
      ],
    );
  }

  getNotificationList() {
    dataService.getNotification(page).then((data) {
      setState(() {
        if (page == 0) {
          notificationList = [];
        }
        notificationList.addAll(data.content);
        last = data.last;
      });
    }).catchError((error) {
      Reusable.handleHttpError(context, error, '');
    });
  }

  Future<ConfirmAction> _asyncConfirmDeleteNotificationDialog(BuildContext context, id, bool all) async {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(18), vertical: 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13.0))),
                content: Container(
                  height: ScreenUtil().setSp(239),
                  width: ScreenUtil().setSp(321),
                  child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setSp(40), bottom: ScreenUtil().setSp(25)),
                      child: Text(
                        all ?  FlutterI18n.translate(context, 'notificationPage.deleteNoti')+"?"
                            :  FlutterI18n.translate(context, 'notificationPage.delete')+'?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setSp(20)),
                      child: Text(
                        FlutterI18n.translate(context, 'notificationPage.sure')+
                            '\n\n'+
                            FlutterI18n.translate(context, 'notificationPage.restore'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CommonColor.textGrey,
                          height: 0.8,
                          fontSize: ScreenUtil().setSp(13),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setSp(30)),
                      child: Row(
                        children: <Widget>[
                          _buildCancelButton(),
                          SizedBox(width: ScreenUtil().setSp(12)),
                          Expanded(
                            child: _builDeleteButton(id, all),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  _buildCancelButton() {
    return SizedBox(
      height: ScreenUtil().setSp(39),
      width: ScreenUtil().setSp(95),
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
            FlutterI18n.translate(context, 'notificationPage.no'),
          style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),
        ),
        color: Color(0xFFEAEAEA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
      ),
    );
  }

  _builDeleteButton(id, bool all) {
    return SizedBox(
      height: ScreenUtil().setSp(39),
      child: RaisedButton(
        onPressed: () {
          deleteNotification(all, id);
          Navigator.of(context).pop();
        },
        child: Text(
          all ?  FlutterI18n.translate(context, 'notificationPage.yes') : FlutterI18n.translate(context, 'notificationPage.yes1'),
          style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),
        ),
        color: Color(0xFFFB101B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
      ),
    );
  }

  @override
  Future initData() {
    return null;
  }

  @override
  Future loadMoreData() async {
    if (!last) {
      page = page + 1;
      getNotificationList();
    } else {
      print('last page..........');
    }
  }

  @override
  Future refreshData() async {
    page = 0;
    getNotificationList();
  }

  deleteNotification(all, id) async {
    try {
      var ids = [];
      if (!all) {
        ids = [id];
      } else if (notificationList != null && notificationList.length > 0) {
        for (var notification in notificationList) {
          ids.add(notification.messageId);
        }
      }
      print(ids);
      final res = await dataService.deleteNotification(ids);
      setState(() {
        if (!all) {
          notificationList = notificationList.where((i) => i.messageId != id).toList();
        } else {
          refreshData();
        }
      });
    } catch (err) {
      Reusable.showTotastError(err.message);
    }
  }

  // updateNotificationStatus(id) async {
  //   try {
  //     final res = await dataService.updateNotificationStatus(id);
  //     if (res != null) {
  //       applicationBloc.changeNotificationBadgeValue(res);
  //     }
  //     setState(() {
  //       for (var notification in notificationList) {
  //         if (notification.id == id) {
  //           notification.statusMobileNotification = NotificationStatus.SEEN;
  //           break;
  //         }
  //       }
  //     });
  //   } catch (err) {
  //     Reusable.showTotastError(err.message);
  //   }
  // }
}
