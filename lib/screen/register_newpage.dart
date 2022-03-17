// import 'dart:io';

// import 'package:app/constant/colors.dart';
// import 'package:app/constant/languagedemo.dart';
// import 'package:app/function/pluginfunction.dart';
// import 'package:app/function/sized.dart';
// import 'package:app/screen/widget/avatar.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import 'widget/alertdialog.dart';

// class NewRegisterPage extends StatefulWidget {
//   const NewRegisterPage({Key? key}) : super(key: key);

//   @override
//   State<NewRegisterPage> createState() => _NewRegisterPageState();
// }

// class _NewRegisterPageState extends State<NewRegisterPage> {
//   FocusScopeNode currentFocus = FocusScopeNode();
//   bool? isLoading = false;
//   late ScrollController scroll;
//   List<Widget>? genderActions = [];
//   List<Widget>? mStatusActions = [];
//   Register register = Register();
//   bool? isLoading = false;
//   bool? alertprofile = false,
//       alertemail = false,
//       alertnumber = false,
//       alertpassword = false,
//       alertfullname = false,
//       alertdob = false,
//       alertgender = false,
//       alertmarital = false,
//       // alertlicense = false,
//       alertprovince = false,
//       alertdistrict = false,
//       alertsalary = false,
//       alertLatestJob = false,
//       alertPrejob = false,
//       alertPreEm = false,
//       alertPreIn = false,
//       alertTotalExp = false,
//       alertprofsum = false,
//       alertcv = false,
//       alertWorkExp = false,
//       alertEdu = false,
//       alertField = false,
//       alertLang = false,
//       alertKey = false;
//   dynamic image, resume;
//   double? imagePercent = 0;
//   double? resumePercent = 0;
//   bool? obscurePassword = true;
//   bool? addWorkEXP = false, addEdu = false;
//   bool? noHaveWorkExp = false;
//   bool? provinceSelected = false;
//   String? imageUrl;
//   List<dynamic>? showFieldStudy = [];
//   List<dynamic>? showLang = [];
//   String? stringdob = '';
//   String? filename = '';
//   List<dynamic>? dialogError = [];
//   File? resumeFile, picture;
//   bool? onKeyboard;
//   dynamic decodedImage;
//   TextEditingController emailControl = TextEditingController();
//   TextEditingController numberControl = TextEditingController();
//   TextEditingController passwordControl = TextEditingController();
//   ImagePicker picker = ImagePicker();
//   Future selectImage(ImageSource imageSource) async {
//     final img = await picker.pickImage(source: imageSource);
//     if (img != null) {
//       int sizeInBytes = File(img.path).lengthSync();
//       double sizeInMb = sizeInBytes / (1024 * 1024);
//       if (sizeInMb > 15) {
//         showDialog<String>(
//             barrierDismissible: false,
//             context: context,
//             builder: (BuildContext context) {
//               return AlertPlainDialog(
//                 title: l.cannotUpload,
//                 actions: [
//                   AlertAction(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     title: l.ok,
//                   )
//                 ],
//                 content: l.thisImageSizelarge,
//               );
//             });
//       } else {
//         setState(() {
//           picture = File(img.path);
//           alertprofile = picture == null;
//         });
//       }
//     }
//   }

//   Future getPictureDevice() async {
//     File? past = picture;

//     var result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'docx']);
//     if (result != null) {
//       picture = File(result.files.single.path!);
//     } else {}

//     if (picture != null) {
//       int sizeInBytes = picture!.lengthSync();
//       double sizeInMb = sizeInBytes / (1024 * 1024);
//       if (sizeInMb > 15) {
//         picture = past;
//         showDialog<String>(
//             barrierDismissible: false,
//             context: context,
//             builder: (BuildContext context) {
//               return AlertPlainDialog(
//                 title: l.cannotUpload,
//                 actions: [
//                   AlertAction(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     title: l.ok,
//                   )
//                 ],
//                 content: l.thisImageSizelarge,
//               );
//             });
//         setState(() {});
//       } else {
//         setState(() {});
//       }
//     } else {
//       picture = past;
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: GestureDetector(
//         onTap: () {
//           currentFocus = FocusScope.of(context);

//           if (!currentFocus.hasPrimaryFocus) {
//             currentFocus.unfocus();
//           }
//         },
//         child: Stack(
//           children: [
//             Scaffold(
//               backgroundColor: AppColors.white,
//               appBar: PreferredSize(
//                   child: AppBar(
//                     backgroundColor: AppColors.white,
//                     iconTheme: const IconThemeData(
//                       color: AppColors.grey,
//                     ),
//                     elevation: 0,
//                   ),
//                   preferredSize: Size.fromHeight(appbarsize(context))),
//               body: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Avatar(
//                       ontap: () {
//                         currentFocus = FocusScope.of(context);

//                         if (!currentFocus.hasPrimaryFocus) {
//                           currentFocus.unfocus();
//                         }
//                         selectpicturefrom(
//                           context,
//                           onPress1: () {
//                             selectImage(ImageSource.camera);

//                             Navigator.pop(context);
//                           },
//                           onPress2: () {
//                             selectImage(ImageSource.gallery);
//                             Navigator.pop(context, 'Cancel');
//                           },
//                         ).then((value) {
//                           setState(() {});
//                         });
//                       },
//                       picture: picture,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
