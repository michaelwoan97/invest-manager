import 'dart:io';

import 'package:flutter/material.dart';


/*
* class: CustomSneakerImage
* purpose: this class is used for creating custom sneaker image
* */
class CustomSneakerImage extends StatefulWidget {
  NetworkImage? myNetworkImage;
  FileImage? myFileImage;
  String imgUrl;
  String placeholderImg;

  CustomSneakerImage({required this.imgUrl, required this.placeholderImg}) {
    //check whether the images are from local or server
    if (this.imgUrl.contains("http")) {
      myNetworkImage = NetworkImage(this.imgUrl);
    } else {
      myFileImage = FileImage(File(this.imgUrl));
    }
  }

  @override
  State<CustomSneakerImage> createState() => _CustomSneakerImageState();
}

class _CustomSneakerImageState extends State<CustomSneakerImage> {
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
    if (_checkLoading == true) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(widget.placeholderImg))));
    } else {
      if (widget.imgUrl.contains("http")) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: widget.myNetworkImage as ImageProvider)));
      } else {
        return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: widget.myFileImage as ImageProvider)));
      }
    }
  }
}
