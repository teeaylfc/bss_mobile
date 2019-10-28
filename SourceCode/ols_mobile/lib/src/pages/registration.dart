import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/registration_page2.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/widgets/custom_checkbox.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage() {}

  @override
  State<StatefulWidget> createState() {
    return _RegistrationState();
  }
}

class _RegistrationState extends State<RegistrationPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DataService dataService = DataService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

   String gender;
  final List genderMaps = [
    {'key': 'nam', 'value': 'Nam'},
    {'key': 'nu', 'value': 'Nữ'}
  ];

  bool _autoValidate = false;

  bool checked = false;

  bool isEmailUsed = false;

  bool loading = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Color(0xffF76016),
          ),
            leading: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios,color: Color(0xffD60202),size: ScreenUtil().setSp(24),))
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: Form(
            autovalidate: _autoValidate,
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    FlutterI18n.translate(context, 'registrationPage.createAccount'),
                    style: TextStyle(fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(5),
                ),
//                isEmailUsed ?
//                Row(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Image.asset('assets/images/loyalty/notice_icon.png', width: ScreenUtil().setSp(15),),
//                    SizedBox(
//                      width: ScreenUtil().setSp(4),
//                    ),
//                    Text("Email đã được sử dụng",style: TextStyle(
//                      fontSize: ScreenUtil().setSp(14),
//                      color: Color(0xffFD4435)
//                    ),)
//                  ],
//                )
//                    : Container()
//                ,
                _showNameInput(),
                _showEmailInput(),
                _showPhoneInput(),
                            Text(
                              FlutterI18n.translate(context, 'profileEditPage.gender'),
                              style: TextStyle(fontSize: ScreenUtil().setSp(12), color: Color(0xFF9B9B9B)),
                            ),
                            Container(
                              width: ScreenUtil().setSp(105),
                              child: DropdownButtonFormField<String>(
                                hint: Text(FlutterI18n.translate(context, 'profileEditPage.gender'),),
                                onChanged: (value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                                value: gender,
                                items: genderMaps.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value['key'],
                                    child: Text(
                                      value['value'],
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(16),
                                        color: Color(0xFF000000),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: CustomCheckbox(
                            value: checked,
                            useTapTarget: false,
                            materialTapTargetSize: null,
                            onChanged: (newValue) {
                              setState(() {
                                checked = !checked;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            'I would like to receive marketing promotions, special offers, inspiration, and policy updates via email.',
                            maxLines: 3,
                            style: TextStyle(
                              color: Color(0xFF8B8B8B),
                              fontSize: ScreenUtil().setSp(12),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: _buildSignupButton(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _showNameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        controller: _nameController,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        style: new TextStyle(color: Color(0xFF9B9B9B), fontSize: ScreenUtil().setSp(18)),
        decoration: InputDecoration(
            labelText:  FlutterI18n.translate(context, 'registrationPage.name'),
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(15), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
            contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF9B9B9B)),
            )),
        validator: _nameInvalid,
        onSaved: (value) => {},
      ),
    );
  }
  String _nameInvalid(value) {
    if(_nameController.text == '' ) {
      return  FlutterI18n.translate(context, 'registrationPage.nameRequire');
    }else if (_nameController.text.length >100){
      return  FlutterI18n.translate(context, 'registrationPage.100Char');
    }
    return null;
  }
  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: _emailController,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: new TextStyle(color: Color(0xFF9B9B9B), fontSize: ScreenUtil().setSp(18)),
        decoration: InputDecoration(
            labelText:  "Email",
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(15), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
            contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF9B9B9B)),
            )),
        validator: validateEmail,
        onSaved: (value) => {},
      ),
    );
  }

  Widget _showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: _phoneController,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        style: new TextStyle(color: Color(0xFF9B9B9B), fontSize: ScreenUtil().setSp(18)),
        decoration: InputDecoration(
            labelText:  "Số điện thoại",
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(15), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
            contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF9B9B9B)),
            )),
        // validator: validateEmail,
        onSaved: (value) => {},
      ),
    );
  }
  _checkEmailExist() async {
    setState(() {
      loading = true;
    });
    try {
      var res = false;
      // final res = await dataService.checkEmailExist(_emailController.text);
      setState(() {
        loading = false;
      });

      if (res) {
        Reusable.showTotastError( FlutterI18n.translate(context, 'registrationPage.phoneUsed'),);
      } else if(res == false && _nameController.text.length >0 && _nameController.text.length < 100){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegistrationPage2(
                      name: _nameController.text,
                      email: _emailController.text,
                    )));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      Reusable.showTotastError(e.message);
    }
  }
  void _validateInputs() async {
    _checkEmailExist();

    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  _buildSignupButton(context) {
    return RaisedGradientButton(
        child: loading
            ? SizedBox(
                width: ScreenUtil().setSp(20),
                height: ScreenUtil().setSp(20),
                child: CircularProgressIndicator(backgroundColor: Colors.white, valueColor: new AlwaysStoppedAnimation<Color>(Color(0XFFFC9A30))))
            : Text(
          FlutterI18n.translate(context, 'registrationPage.continue'),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
              ),
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFD90D0D), Color(0xFFD90D0D)],
        ),
        onPressed: () {
          if(_nameController.text.length >0  && _nameController.text.length < 100) {
            FocusScope.of(context).requestFocus(new FocusNode());
          }
          _validateInputs();
        });
  }

}
