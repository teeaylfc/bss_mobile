import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ReviewDialog extends StatefulWidget {
  final int companyId;

  ReviewDialog({this.companyId});

  @override
  State<StatefulWidget> createState() {
    return _ReviewDialogState();
  }
}

class _ReviewDialogState extends State<ReviewDialog> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DataService dataService = DataService();
  double rate = 5;
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _reviewController = TextEditingController(text: '');
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: new AppBar(
            iconTheme: IconThemeData(color: CommonColor.textRed),
            backgroundColor: Colors.white,
            elevation: 0.5,
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Send',
                  style: TextStyle(color: CommonColor.textRed),
                ),
                onPressed: () {
                  _postComment();
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                Text('Tap to rate', style: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0xFF9B9B9B))),
                FlutterRatingBar(
                  initialRating: this.rate,
                  itemSize: 30,
                  fillColor: Color(0xFFF76016),
                  borderColor: Color(0xFFF76016),
                  onRatingUpdate: (rating) {
                    setState(() {
                      rate = rating;
                    });
                  },
                ),
                new TextFormField(
                  controller: _titleController,
                  validator: (value) => value.isEmpty ? 'Title can\'t be empty' : null,
                  onSaved: (value) => {},
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(fontSize: 14, color: Color(0xFF9B9B9B)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE7E7E7))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                ),
                new TextFormField(
                  controller: _reviewController,
                  validator: (value) => value.isEmpty ? 'Review can\'t be empty' : null,
                  onSaved: (value) => {},
                  maxLines: 5,
                  decoration: const InputDecoration(
                      labelText: 'Review',
                      labelStyle: TextStyle(fontSize: 14, color: Color(0xFF9B9B9B)),
                      helperText: 'Share your experience and help others make better choices',
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE7E7E7))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                ),
              ],
            ),
          )),
    );
  }

  _postComment() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    try {
      setState(() {
        loading = true;
      });
      final res = await dataService.writeComment(widget.companyId, rate, _titleController.text, _reviewController.text);
      Navigator.pop(context, res);

      setState(() {
        loading = false;
      });
    } catch (error) {
      setState(() {
        loading = false;
      });
      _showError(error.message);
    }
  }

  _showError(error) {
    Reusable.showTotastError(error);
  }
}
