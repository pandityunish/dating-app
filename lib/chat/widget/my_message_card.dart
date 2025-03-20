import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ristey/chat/colors.dart';
import 'package:ristey/chat/widget/message_video_player.dart';
import 'package:ristey/global_vars.dart';
import 'package:voice_message_package/voice_message_package.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final String status;
  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(message);
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
          minWidth: 30,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: identifyTextType(message) == "Website URL"
                    ? AnyLinkPreview(
                        link: message,
                        displayDirection: UIDirection.uiDirectionVertical,
                        showMultimedia: true,
                        bodyMaxLines: 5,
                        removeElevation: true,
                        backgroundColor: mainColor,
                        bodyTextOverflow: TextOverflow.ellipsis,
                        titleStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        bodyStyle:
                            const TextStyle(color: Colors.black, fontSize: 12),
                      )
                    : identifyTextType(message) == "Image URL"
                        ? Image.network(
                            message,
                            height: 300,
                          )
                        : identifyTextType(message) == "Video URL"
                            ? MessageVideoPlayer(videoUrl: message)
                            : identifyTextType(message) == "Audio URL"
                                ? VoiceMessageView(
                                    backgroundColor: mainColor,
                                    activeSliderColor: Colors.white,
                                    circlesColor: Colors.black,
                                    playPauseButtonLoadingColor:
                                        const Color.fromRGBO(0, 0, 0, 1),
                                    controller: VoiceController(
                                      isFile: false,
                                      maxDuration: const Duration(minutes: 5),
                                      audioSrc: message,
                                      onComplete: () {
                                        /// do something on complete
                                      },
                                      onPause: () {
                                        /// do something on pause
                                      },
                                      onPlaying: () {
                                        /// do something on playing
                                      },
                                      onError: (err) {
                                        /// do somethin on error
                                      },
                                    ),
                                    innerPadding: 12,
                                    cornerRadius: 20,
                                  )
                                : Text(
                                    message,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: mainColor,
                                        fontFamily: 'Sans-serif'),
                                  ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 8,
                        fontFamily: 'Sans-serif',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      (status == "seen")
                          ? FontAwesomeIcons.checkDouble
                          : FontAwesomeIcons.check,
                      color: mainColor,
                      size: 10,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class MyImageCard extends StatefulWidget {
//   final String url;
//   final String date;
//   final String imageName;

//   const MyImageCard(
//       {Key? key,
//       required this.url,
//       required this.date,
//       required this.imageName})
//       : super(key: key);

//   @override
//   State<MyImageCard> createState() => _MyImageCardState();
// }

// class _MyImageCardState extends State<MyImageCard> {
//   String imagepath = '';

//   @override
//   void initState() {
//     super.initState();

//     if (imgDict.doesUrlExistInSet(widget.url)) {
//       setState(() {
//         imagepath = imgDict.path(widget.url);
//       });
//     } else {
//       downloadImage();
//     }
//   }

//   downloadImage() async {
//     var path = await ExternalFilefunction()
//         .downloadImage(widget.url, widget.imageName);
//     if (path == 'noPermission') {
//       Navigator.of(context).pop();
//     } else {
//       setState(() {
//         imagepath = path.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width - 40,
//           maxHeight: MediaQuery.of(context).size.width * 0.8,
//         ),
//         child: Card(
//           elevation: 1,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           color: messageColor,
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//           child: Stack(
//             children: [
//               Padding(
//                   padding: const EdgeInsets.only(
//                     left: 10,
//                     right: 30,
//                     top: 5,
//                     bottom: 20,
//                   ),
//                   child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => ImageSliderPopUp(
//                                   galleryItems: [widget.url],
//                                 )));
//                       },
//                       child: (imagepath == '')
//                           ? Container()
//                           : Image(image: FileImage(File(imagepath))))),
//               Positioned(
//                 bottom: 4,
//                 right: 10,
//                 child: Row(
//                   children: [
//                     Text(
//                       widget.date,
//                       style: TextStyle(
//                         fontSize: 8,
//                         fontFamily: 'Sans-serif',
//                         fontWeight: FontWeight.w400,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyPDFCard extends StatefulWidget {
//   final String url;
//   final String date;
//   final String pdfName;

//   const MyPDFCard({
//     Key? key,
//     required this.url,
//     required this.date,
//     required this.pdfName,
//   }) : super(key: key);

//   @override
//   _MyPDFCardState createState() => _MyPDFCardState();
// }

// class _MyPDFCardState extends State<MyPDFCard> {
//   String _pdfPath = '';

//   @override
//   void initState() {
//     super.initState();

//     _downloadPDF();
//   }

//   Future<void> _downloadPDF() async {
//     try {
//       final appDir = await getApplicationDocumentsDirectory();
//       final pdfPath = '${appDir.path}/${widget.pdfName}';

//       // Check if the PDF file already exists
//       if (File(pdfPath).existsSync()) {
//         setState(() {
//           _pdfPath = pdfPath;
//         });
//       } else {
//         // Download the PDF file from the URL
//         final response = await Dio().get(widget.url,
//             options: Options(responseType: ResponseType.bytes));

//         final file = File(pdfPath);
//         await file.writeAsBytes(response.data);

//         setState(() {
//           _pdfPath = pdfPath;
//         });
//       }
//     } catch (e) {
//       print('Error downloading PDF: $e');
//     }
//   }

//   void _openPDF() {
//     if (_pdfPath.isNotEmpty) {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => PDFScreen(pdfPath: _pdfPath),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width - 40,
//             maxHeight: MediaQuery.of(context).size.width * 0.8,
//           ),
//           child: Card(
//             elevation: 1,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             color: messageColor,
//             margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 10,
//                     right: 30,
//                     top: 5,
//                     bottom: 20,
//                   ),
//                   // child: GestureDetector(
//                   child: InteractiveViewer(
//                     child: (_pdfPath.isEmpty)
//                         ? Container()
//                         : GestureDetector(
//                             onLongPress: _openPDF,
//                             // child: PDF(
//                             //   enableSwipe: true,
//                             //   swipeHorizontal: true,
//                             //   autoSpacing: false,
//                             //   pageFling: false,
//                             //   pageSnap: true,
//                             //   fitPolicy: FitPolicy.BOTH,
//                             // ).fromAsset(_pdfPath),
//                             child: Container(),
//                           ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 4,
//                   right: 10,
//                   child: Text(
//                     widget.date,
//                     style: TextStyle(
//                       fontSize: 8,
//                       fontFamily: 'Sans-serif',
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyVideoCard extends StatefulWidget {
//   final String videoUrl;
//   final String date;
//   final String imageName;
//   const MyVideoCard(
//       {Key? key,
//       required this.imageName,
//       required this.videoUrl,
//       required this.date})
//       : super(key: key);

//   @override
//   State<MyVideoCard> createState() => _MyVideoCardState();
// }

// class _MyVideoCardState extends State<MyVideoCard> {
//   VideoPlayerController? _videoPlayerController;
//   Future<void>? _initializeVideoPlayerFuture;
//   String imagepath = '';
//   @override
//   void initState() {
//     super.initState();
//     _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _videoPlayerController!.initialize();
//     _videoPlayerController!.play();
//     if (imgDict.doesUrlExistInSet(widget.videoUrl)) {
//       setState(() {
//         imagepath = imgDict.path(widget.videoUrl);
//       });
//     } else {
//       downloadImage();
//     }
//   }

//   downloadImage() async {
//     var path = await ExternalFilefunction()
//         .downloadImage(widget.videoUrl, widget.imageName);
//     if (path == 'noPermission') {
//       Navigator.of(context).pop();
//     } else {
//       setState(() {
//         imagepath = path.toString();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _videoPlayerController!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width - 40,
//           maxHeight: MediaQuery.of(context).size.width * 0.8,
//         ),
//         child: Card(
//           elevation: 1,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           color: messageColor,
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//           child: Stack(
//             children: [
//               Padding(
//                   padding: const EdgeInsets.only(
//                     left: 10,
//                     right: 30,
//                     top: 5,
//                     bottom: 20,
//                   ),
//                   child: (imagepath != '')
//                       // ? VideoPlayerWidget(
//                       //     file: File(imagepath),
//                       //   )
//                       ? ChatVideoWidget(
//                           videopath: imagepath,
//                         )
//                       : Container()
//                   // FutureBuilder<void>(
//                   //   future: _initializeVideoPlayerFuture,
//                   //   builder:
//                   //       (BuildContext context, AsyncSnapshot<void> snapshot) {
//                   //     if (snapshot.connectionState == ConnectionState.waiting) {
//                   //       return CircularProgressIndicator();
//                   //     } else if (snapshot.hasError) {
//                   //       return Text('Error: ${snapshot.error}');
//                   //     } else {
//                   //       return AspectRatio(
//                   //         aspectRatio: _videoPlayerController!.value.aspectRatio,
//                   //         child: VideoPlayer(_videoPlayerController!),
//                   //       );
//                   //     }
//                   //   },
//                   // ),
//                   ),
//               Positioned(
//                 bottom: 4,
//                 right: 10,
//                 child: Row(
//                   children: [
//                     Text(
//                       widget.date,
//                       style: TextStyle(
//                         fontSize: 8,
//                         fontFamily: 'Sans-serif',
//                         fontWeight: FontWeight.w400,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Icon(
//                       FontAwesomeIcons.checkDouble,
//                       color: main_color,
//                       size: 15,
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ChatDate extends StatefulWidget {
  const ChatDate({super.key, required this.txt});
  final txt;

  @override
  State<ChatDate> createState() => _ChatDateState();
}

class _ChatDateState extends State<ChatDate> {
  String getdate() {
    var dt = widget.txt.split("-");
    var data = "${dt[2]}-${dt[1]}-${dt[0]}";
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            // border: Border.all(),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            getdate(),
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}
