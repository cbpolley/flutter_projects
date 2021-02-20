// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';

// import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

// class ImagePickerWidget extends StatefulWidget {
//   @override
//   _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
// }

// class _ImagePickerWidgetState extends State<ImagePickerWidget> {
//   File _image;
//   final picker = ImagePicker();

//   Future<void> _imgFromCamera() async {
//     final pickedFile = await picker.getImage(
//       source: ImageSource.camera,
//       maxWidth: 200,
//       maxHeight: 200,
//       imageQuality: 50,
//     );
//     setState(() {
//       _image = File(pickedFile.path);
//     });
//     getFilePath();
//   }

//   Future<void> _imgFromGallery() async {
//     final pickedFile = await ImagePicker().getImage(
//       source: ImageSource.gallery,
//       maxWidth: 200,
//       maxHeight: 200,
//       imageQuality: 50,
//     );
//     setState(() {
//       _image = File(pickedFile.path);
//     });
//     getFilePath();
//   }

//   Future getFilePath() async {
//     final String path = _image.path;

//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     String appDocPath = appDocDir.path;
//     // App
//     final File newImage = await _image.copy('$appDocPath/test-image.png');

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('test_image', path);
//   }

//   void _showPicker(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return SafeArea(
//             child: Container(
//               child: new Wrap(
//                 children: <Widget>[
//                   new ListTile(
//                       leading: new Icon(Icons.photo_library),
//                       title: new Text('Photo Library'),
//                       onTap: () {
//                         _imgFromGallery();
//                         Navigator.of(context).pop();
//                       }),
//                   new ListTile(
//                     leading: new Icon(Icons.photo_camera),
//                     title: new Text('Camera'),
//                     onTap: () {
//                       _imgFromCamera();
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 0.0,
//       right: 0.0,
//       child: GestureDetector(
//         onTap: () {
//           _showPicker(context);
//         },
//         child: CircleAvatar(
//             radius: 15.0,
//             child: Icon(Icons.edit),
//             backgroundColor: Theme.of(context).buttonColor),
//       ),
//     );
//   }
// }
