import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ristey/global_vars.dart';

class ImageSliderPopUp extends StatefulWidget {
  ImageSliderPopUp({
    super.key,
    this.galleryItems,
    required this.currentindex,
  });
  var galleryItems;
  int currentindex;
  @override
  State<ImageSliderPopUp> createState() => _ImageSliderPopUpState();
}

class _ImageSliderPopUpState extends State<ImageSliderPopUp> {
  var galleryItems;
  @override
  void initState() {
    super.initState();
    setState(() {
      galleryItems = widget.galleryItems;
    });
  }

  List<Widget> _createImgList() {
    if (galleryItems == null) {
      return [const Text("image not found")];
    } else {
      return List<Widget>.generate(galleryItems.length, (int index) {
        return PhotoView(
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          imageProvider: NetworkImage(
            galleryItems[index],
            // fit: BoxFit.cover,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Stack(
        children: [
          Container(
            child: ImageSlideshow(
                indicatorRadius: 5,
                initialPage: widget.currentindex,
                height: MediaQuery.of(context).size.height * 1,
                // height: MediaQuery.of(context).size.height * 0.5,
                // width: MediaQuery.of(context).size.width,

                /// The color to paint the indicator.
                indicatorColor: mainColor,
                isLoop: false,
                children: _createImgList() //returns list of images

                ),
          ),
          Container(
            child: Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width * 0.85,
              // right: 25,
              child: GestureDetector(
                onTap: () {
                  // print("Print");
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(40)),
                  child: Icon(Icons.close,color: Colors.white,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
