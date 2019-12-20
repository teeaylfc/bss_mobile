import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/http_client.dart';
import 'package:bss_mobile/src/models/account_info_model.dart';
import 'package:bss_mobile/src/models/user_modal.dart';
import 'package:bss_mobile/src/pages/login.dart';
import 'package:bss_mobile/src/pages/profile.dart';
import 'package:bss_mobile/src/pages/profile_menu.dart';
import 'package:bss_mobile/src/service/auth_service.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/confirm_dialog.dart';
import 'package:bss_mobile/src/widgets/notification_popup.dart';
import 'package:bss_mobile/src/widgets/raised_gradient_button.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'change_password.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'main.dart';

class ProfileEditPage extends StatefulWidget {
  ProfileEditPage() {}

  @override
  State<StatefulWidget> createState() {
    return _ProfileEditPageState();
  }
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ApplicationBloc applicationBloc;
  DataService dataService = DataService();

  final List genderMaps = [
    {'key': 'nam', 'value': 'Nam'},
    {'key': 'nu', 'value': 'Nữ'}
  ];

  AuthService authService = AuthService();
  AccountInfo accountInfo;
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _phoneController = TextEditingController(text: '');

  bool connectedFacebook = false;
  bool connectedGoogle = false;
  String gender;
  File fileImage;
  String imageUrl;
  int idImgUpload;
  bool _autoValidate = true;
  bool checked = false;
  bool loading = false;
  bool facebookLoading = false;
  bool googleLoading = false;
  String avatarUrl;

  @override
  void initState() {
    super.initState();
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    getAccountInfo();
  }

  getAccountInfo() async {
    try {
      final res = await authService.getAccountInfo();
      if (res != null) {
        setState(() {
          accountInfo = res;
          _nameController.text = accountInfo.fullName;
          _emailController.text = accountInfo.email;
          _phoneController.text = accountInfo.phone;
          gender = accountInfo.gender;
          imageUrl = accountInfo.imageURL;
        });
      }
    } catch (error) {
      _showMessageDialog(false, error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: ScreenUtil().setSp(20),
                color: CommonColor.textBlack,
              )),
          title: Center(
            child: Text(
              FlutterI18n.translate(context, 'profileEditPage.updateAccount'),
              style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
          elevation: 0.7,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: _buildDoneButton(context),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xfF7F7F7),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                      offset: Offset(
                          0.0, // horizontal, move right 10
                          0.2 // vertical, move down 10
                          ),
                    )
                  ]),
                  width: ScreenUtil().setSp(345),
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setSp(15), ScreenUtil().setSp(18), ScreenUtil().setSp(15), ScreenUtil().setSp(15)),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 30, 18, 0),
                      child: Form(
                        autovalidate: _autoValidate,
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _uploadAvatar(context);
                                  },
                                  child: CircleAvatar(
                                    radius: 40.0,
                                    backgroundImage: fileImage == null
                                        ? (imageUrl != null ? NetworkImage(imageUrl) : AssetImage('assets/images/blank_profile.png'))
                                        : FileImage(fileImage),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(60, 60, 0, 0),
                                  width: ScreenUtil().setSp(22),
                                  height: ScreenUtil().setSp(22),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE7E7E7),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        _uploadAvatar(context);
                                      },
                                      child: Icon(
                                        Icons.photo_camera,
                                        color: CommonColor.textBlack,
                                        size: ScreenUtil().setSp(14),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            new TextFormField(
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                              ),
                              textCapitalization: TextCapitalization.words,
                              controller: _nameController,
                              validator: _nameInvalid,
                              onSaved: (value) => {},
                              decoration:  InputDecoration(
                                labelText: FlutterI18n.translate(context, 'profileEditPage.name'),
                                labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9B9B9B)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE7E7E7),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE7E7E7),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setSp(10),
                            ),
                            new TextField(
                              enabled: false,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                              ),
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF9B9B9B),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color(0xFFE7E7E7),
                                )),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE7E7E7),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setSp(15),
                            ),
                            TextFormField(
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                              ),
                              keyboardType: TextInputType.number,
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: FlutterI18n.translate(context, 'profileEditPage.phone'),
                                labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9B9B9B)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE7E7E7),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE7E7E7),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setSp(20),
                            ),
                            Text(
                              FlutterI18n.translate(context, 'profileEditPage.gender'),
                              style: TextStyle(fontSize: ScreenUtil().setSp(12), color: Color(0xFF9B9B9B)),
                            ),
                            Container(
                              width: ScreenUtil().setSp(105),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                      canvasColor: Colors.white,
                                    ),
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
                            ),
                            SizedBox(
                              height: ScreenUtil().setSp(30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        0.2, // vertical, move down 10
                      ),
                    )
                  ]),
                  width: ScreenUtil().setSp(345),
                  height: ScreenUtil().setSp(83),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setSp(135),
                        height: ScreenUtil().setSp(83),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                        ),
                        child: Image.asset(
                          "assets/images/loyalty/codeImage.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(15),
                      ),
                      Container(
                        width: ScreenUtil().setSp(112),
                        padding: EdgeInsets.only(top: ScreenUtil().setSp(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                        FlutterI18n.translate(context, 'profileEditPage.referralCode'),
                              style: TextStyle(fontSize: ScreenUtil().setSp(10), color: Color(0xff696969)),
                            ),
                            SizedBox(
                              height: ScreenUtil().setSp(5),
                            ),
                            Text(
                              "0123455646789",
                              style: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0xff343434), fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(21),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setSp(50)),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.share,
                                color: Color(0xff0A4DD0),
                                size: 14,
                              ),
                              Text(
                                  FlutterI18n.translate(context, 'profileEditPage.share'),
                                style: TextStyle(color: Color(0xff0A4DD0), fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildDoneButton(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: RaisedGradientButton(
          child: Text(
              FlutterI18n.translate(context, 'profileEditPage.save'),
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(12),
            ),
          ),
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFD90D0D), Color(0xFFD90D0D)],
          ),
          width: ScreenUtil().setSp(67),
          height: ScreenUtil().setSp(28),
          onPressed: () async {
           if (_nameController.text.length != 0) {
             SystemChannels.textInput.invokeMethod('TextInput.hide');
             updateAccountInfo(context);
              Navigator.pop(context);
           }
          }),
    );
  }

  updateAccountInfo(context) async {
    setState(() {
      loading = true;
    });
    try {
      AccountInfo res;
      if (_nameController.text != '') {
        res = await dataService.updateProfile(_nameController.text, _phoneController.text, gender.toString());
        User user = applicationBloc.currentUserValue.value;
        User newUser = User(username: user.username, fullName: res.fullName, imageURL: user.imageURL, image: user.image);
        applicationBloc.changeCurrentUser(newUser);
        Reusable.showMessageDialog(true, FlutterI18n.translate(context, 'profileEditPage.updateSuccess'), context);
      }
      setState(() {
        loading = false;
      });
    } catch (error) {
      setState(() {
        loading = false;
      });
      Reusable.showTotastError(error.message);
      if (error.action == HttpActionError.LOGIN) {
        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new LogInPage();
            },
            fullscreenDialog: true));
      }
    }
  }

  _showMessageDialog(success, text) {
    containerForSheet<String>(
        context: context,
        child: Container(
          child: MessagePopup(success: success, title1: text),
        ));
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop();
          });
          return child;
        }).then<void>((T value) {});
  }

  _loginFacebook() async {
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        var inforByFacebook = await authService.getInforFacebook(accessToken.token);
        _connectSocial(SocialConnectionType.FACEBOOK, inforByFacebook['name'].toString(), inforByFacebook['email'].toString().replaceAll('\u0040', '@'),
            inforByFacebook['id'], inforByFacebook['picture']['data']['url']);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        _showMessageDialog(
            false,
            'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  _loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      _connectSocial(SocialConnectionType.GOOGLE, googleUser.displayName, googleUser.email, googleUser.id, googleUser.photoUrl);
    } catch (error) {
      _showMessageDialog(false, error);
    }
  }

  _disconnectSocial(provider) async {
    if (!facebookLoading && !googleLoading) {
      _updateSocialLoadingState(provider, true);
      try {
        await authService.disconnectSocial(provider);
        _showMessageDialog(true, 'Unlink $provider successfully !');
        _updateSocialState(provider, false);
      } on HttpError catch (error) {
        _showMessageDialog(false, error.message);
      }
      _updateSocialLoadingState(provider, false);
    }
  }

  _connectSocial(provider, name, email, userId, imageUrl) async {
    if (!facebookLoading && !googleLoading) {
      _updateSocialLoadingState(provider, true);
      try {
        await authService.connectSocial(provider, name, email, userId, imageUrl);
        _showMessageDialog(true, 'Connect $provider successfully !');
        _updateSocialState(provider, true);
      } on HttpError catch (error) {
        _showMessageDialog(false, error.message);
      }
      _updateSocialLoadingState(provider, false);
    }
  }

  _updateSocialState(provider, status) {
    if (provider == SocialConnectionType.FACEBOOK) {
      setState(() {
        connectedFacebook = status;
      });
    }
    if (provider == SocialConnectionType.GOOGLE) {
      setState(() {
        connectedGoogle = status;
      });
    }
  }

  _updateSocialLoadingState(provider, status) {
    if (provider == SocialConnectionType.FACEBOOK) {
      setState(() {
        facebookLoading = status;
      });
    }
    if (provider == SocialConnectionType.GOOGLE) {
      setState(() {
        googleLoading = status;
      });
    }
  }

  _uploadAvatar(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title:  Text( FlutterI18n.translate(context, 'profileEditPage.changeAvatar'),),
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text( FlutterI18n.translate(context, 'profileEditPage.cancel'),)),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child:  Text( FlutterI18n.translate(context, 'profileEditPage.camera'),),
                onPressed: () {
                  _uploadFromCamera();
                  Navigator.of(context).pop();
                },
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  _uploadFromGallery();
                  Navigator.of(context).pop();
                },
                child:  Text( FlutterI18n.translate(context, 'profileEditPage.gallery'),),
              )
            ],
          );
        });
  }

  _uploadFromCamera() async{
    await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200.0,
      maxWidth: 1200.0,
    ).then((fileImage) async {
      File croppedFile = await ImageCropper.cropImage(
        circleShape: true,
        sourcePath: fileImage.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (croppedFile != null) {
        ConfirmAction action = await _asyncConfirmDialog(context, croppedFile);
        if (action.toString() == 'ConfirmAction.ACCEPT') {
          _uploadFinal(croppedFile);
        }
      }
    });
  }

  _uploadFromGallery() async {
    await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200.0,
      maxWidth: 1200.0,
    ).then((fileImage) async {
      File croppedFile = await ImageCropper.cropImage(
        circleShape: true,
        sourcePath: fileImage.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 1200,
        maxHeight: 2000,
      );
      if (croppedFile != null) {
        ConfirmAction action = await _asyncConfirmDialog(context, croppedFile);
        if (action.toString() == 'ConfirmAction.ACCEPT') {
          _uploadFinal(croppedFile);
        }
      }
    });
  }

  _uploadFinal(file) async {
    print("New file " + file.toString());
    setState(() {
      fileImage = file;
    });
    try {
      AccountInfo res = await dataService.upLoadAvatar(file);
      avatarUrl = res.imageURL;
      User user = applicationBloc.currentUserValue.value;
      User newUser = User(username: user.username, fullName: user.fullName, imageURL: avatarUrl, image: user.image);

      applicationBloc.changeCurrentUser(newUser);
      _showMessageDialog(true,  FlutterI18n.translate(context, 'profileEditPage.avatarSuccess'),);
    } catch (error) {
      print(error.message);
      if (fileImage != null) {
        _showMessageDialog(false,  FlutterI18n.translate(context, 'profileEditPage.avatarFail'),);
      }
    }
  }

  String _nameInvalid(value) {
    if (_nameController.text == '') {
      return  FlutterI18n.translate(context, 'registrationPage.nameRequire');
    } else if (_nameController.text.length > 100) {
      return  FlutterI18n.translate(context, 'registrationPage.100Char');
    }
    return null;
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, File file) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ConfirmDialog(
          avatarPreview: true,
          avatarFile: file,
          width: ScreenUtil().setSp(297),
          height: ScreenUtil().setSp(220),
          title: FlutterI18n.translate(context, 'profileEditPage.sure'),
          callbackConfirm: () {},
        );
      },
    );
  }
  
}
