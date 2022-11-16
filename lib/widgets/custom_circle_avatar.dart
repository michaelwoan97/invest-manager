import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/*
* class: CustomCircleAvatar
* purpose: this class is used for creating custom circle avatar
* */
// class CustomCircleAvatar extends StatefulWidget {
//   NetworkImage? myNetworkImage;
//   FileImage? myFileImage;
//   String imgUrl;
//   String placeholderImg;
//
//   CustomCircleAvatar({required this.imgUrl, required this.placeholderImg}) {
//     //check whether the images are from local or server
//     if (this.imgUrl.contains("http")) {
//       myNetworkImage = NetworkImage(this.imgUrl);
//     } else {
//       if (!kIsWeb) {
//         myFileImage = FileImage(File(this.imgUrl));
//       }
//     }
//   }
//
//   @override
//   State<CustomCircleAvatar> createState() => _CustomCircleAvatarState();
// }
//
// class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
//   bool _checkLoading = true;
//
//   @override
//   void initState() {
//     //check whether the images are from local or server
//     if (widget.imgUrl.contains("http")) {
//       try{
//         widget.myNetworkImage!.resolve(ImageConfiguration()).addListener(
//             ImageStreamListener((ImageInfo image, bool synchronousCall) {
//               if (mounted) {
//                 setState(() => _checkLoading = false);
//               }
//             }));
//       } on Exception catch (err) {
//         print(err);
//       }
//
//     } else {
//       if (!kIsWeb) {
//         try{
//           widget.myFileImage!.resolve(ImageConfiguration()).addListener(
//               ImageStreamListener((ImageInfo image, bool synchronousCall) {
//                 if (mounted) {
//                   setState(() => _checkLoading = false);
//                 }
//               }));
//         } on Exception catch (err){
//           print(err);
//         }
//
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_checkLoading == true) {
//       return new CircleAvatar(
//         backgroundImage: AssetImage(widget.placeholderImg),
//       );
//     } else {
//       if (widget.imgUrl.contains("http")) {
//         return new CircleAvatar(
//           backgroundImage: widget.myNetworkImage,
//         );
//       } else {
//         // check whether the app is being used on the web
//         return kIsWeb
//             ? new CircleAvatar(
//                 backgroundImage: AssetImage(widget.placeholderImg),
//               )
//             : new CircleAvatar(
//                 backgroundImage: widget.myFileImage,
//               );
//       }
//     }
//   }
// }


class CustomCircleAvatar extends StatefulWidget {
  String images;
  String placeholderImg;
  Uint8List? decodeImage;
  MemoryImage? displayImg;

  CustomCircleAvatar({super.key, required this.images, required this.placeholderImg}) {
    if (images.isNotEmpty) {
      decodeImage = base64Decode(images);
      displayImg = MemoryImage(decodeImage!);
    } else {
      displayImg = null;
    }
  }

  @override
  State<CustomCircleAvatar> createState() => _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  bool _checkLoading = true;

  @override
  void initState() {
    super.initState();
    if(widget.displayImg != null){
      widget.displayImg!
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener((image, synchronousCall) {
        if (mounted) {
          setState(() {
            _checkLoading = false;
          });
        }
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkLoading == true) {
      return CircleAvatar(
        backgroundImage: AssetImage(widget.placeholderImg),
      );
    } else {
      return CircleAvatar(
        backgroundImage: widget.displayImg,
      );
    }
  }
}
