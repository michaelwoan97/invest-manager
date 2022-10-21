import 'dart:io';

import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatefulWidget {
  NetworkImage? myNetworkImage;
  FileImage? myFileImage;
  String imgUrl;
  String placeholderImg;

  CustomCircleAvatar({required this.imgUrl, required this.placeholderImg}) {
    //check whether the images are from local or server
    if (this.imgUrl.contains("http")) {
      myNetworkImage = NetworkImage(this.imgUrl);
    } else {
      myFileImage = FileImage(File(this.imgUrl));
    }
  }

  @override
  State<CustomCircleAvatar> createState() => _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  bool _checkLoading = true;

  @override
  void initState() {
    //check whether the images are from local or server
    if (widget.imgUrl.contains("http")) {
      widget.myNetworkImage!.resolve(ImageConfiguration()).addListener(
          ImageStreamListener((ImageInfo image, bool synchronousCall) {
            if (mounted) {
              setState(() => _checkLoading = false);
            }
          }));
    } else {
      widget.myFileImage!.resolve(ImageConfiguration()).addListener(
          ImageStreamListener((ImageInfo image, bool synchronousCall) {
            if (mounted) {
              setState(() => _checkLoading = false);
            }
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_checkLoading == true){
      return new CircleAvatar(
        backgroundImage: AssetImage(widget.placeholderImg),
      );
    } else {
      if (widget.imgUrl.contains("http")){
        return new CircleAvatar(
          backgroundImage: widget.myNetworkImage,
        );
      } else {
        return new CircleAvatar(
          backgroundImage: widget.myFileImage,
        );
      }
    }
  }
}
