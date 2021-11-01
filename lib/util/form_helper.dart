// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class FormHelper {
//   Widget imageSelector(String fileName, Function onFileSelect) {
//     Future<PickedFile> _imageFile;
//     ImagePicker _picker = ImagePicker();

//     return Column(children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             height: 30,
//             width: 35,
//             child: IconButton(
//               icon: const Icon(Icons.image, size: 35),
//               onPressed: () {
//                 _picker.getImage(source: ImageSource.gallery);
//                 _imageFile.then((file) => {onFileSelect(file)});
//               },
//             ),
//           ),
//           SizedBox(
//             height: 30,
//             width: 35,
//             child: IconButton(
//               icon: const Icon(Icons.image, size: 35),
//               onPressed: () {
//                 _imageFile = _picker.getImage(source: ImageSource.camera);
//                 _imageFile.then((file) => {onFileSelect(file)});
//               },
//             ),
//           ),
//           fileName != null
//               ? Image.file(File(fileName), width: 35, height: 35)
//               : Container()
//         ],
//       ),
//     ]);
//   }
// }
