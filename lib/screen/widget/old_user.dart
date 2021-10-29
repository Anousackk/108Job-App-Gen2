import 'package:flutter/material.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:app/api/auth.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/AuthenScreen/register_page.dart';
import 'package:app/screen/ControlScreen/bottom_navigation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class OlduserToRegister extends StatefulWidget {
  const OlduserToRegister({Key? key, this.userID}) : super(key: key);
  final String? userID;
  @override
  _OlduserToRegisterState createState() => _OlduserToRegisterState();
}

class _OlduserToRegisterState extends State<OlduserToRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            // actions: [
            //   IconButton(
            //       icon: Text(
            //         'search',
            //         style: TextStyle(
            //           fontFamily: 'FontAwesomeProRegular',
            //           fontSize: 20,
            //           color: Colors.white,
            //         ),
            //       ),
            //       color: Colors.white,
            //       onPressed: () => {
            //             // Navigator.push(
            //             //   context,
            //             //   PageRouteBuilder(
            //             //     pageBuilder: (_, __, ___) => SearchPage(),
            //             //     transitionDuration: Duration(seconds: 0),
            //             //   ),
            //             // )
            //           })
            // ],
            backgroundColor: AppColors.blue,

            centerTitle: true,
            title: Text(
              indexL == 0 ? 'My profile' : 'ຂໍ້ມູນສ່ວນຕົວ',
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            elevation: 0.0,
            bottomOpacity: 0.0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: SizedBox(
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    indexL == 0
                        ? 'For old user please add new information'
                        : 'ທ່ານແມ່ນສະມາຊິກເກົ່າ\nກະລຸນາເພິ່ມຂໍ້ມູນຊຸດໃໝ່',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: mediaWidthSized(context, 18),
                        color: AppColors.blue,
                        fontFamily: 'PoppinsSemiBold'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'user-plus',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 5,
                        color: AppColors.blue,
                        fontFamily: 'FontAwesomeProRegular'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            // settings: RouteSettings(name: "/login"),
                            builder: (context) => RegisterPage(
                                  isOlduser: true,
                                  userID: widget.userID,
                                )),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.blue,
                      ),
                      child: Container(
                        height: mediaWidthSized(context, 10),
                        width: mediaWidthSized(context, 2.2),
                        alignment: Alignment.center,
                        child: Text(
                          indexL == 0 ? 'Add information' : 'ເພິ່ມຂໍ້ມູນ',
                          style: TextStyle(
                              color: AppColors.white,
                              fontFamily: 'PoppinsRegular',
                              fontSize: indexL == 0
                                  ? mediaWidthSized(context, 25)
                                  : mediaWidthSized(context, 22)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  InkWell(
                    onTap: () {
                      SmartDialog.showLoading(
                          background: AppColors.white, msg: l.loading);
                      AuthUtil().removeToken();
                      Future.delayed(const Duration(milliseconds: 1000))
                          .then((value) {
                        SmartDialog.dismiss();
                        pageIndex = 0;
                        currentToken = null;
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (Route<dynamic> route) => false);
                        pageIndex = 0;
                        // Phoenix.rebirth(context);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black, width: 1)),
                      child: Container(
                        height: mediaWidthSized(context, 14),
                        width: mediaWidthSized(context, 3),
                        alignment: Alignment.center,
                        child: Text(
                          indexL == 0 ? 'Logout' : 'ອອກຈາກລະບົບ',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PoppinsRegular',
                              fontSize: indexL == 0
                                  ? mediaWidthSized(context, 27)
                                  : mediaWidthSized(context, 24)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
