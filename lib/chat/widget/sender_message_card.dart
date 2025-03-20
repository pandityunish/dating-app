import 'dart:io';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'package:dio/dio.dart';
import 'package:ristey/global_vars.dart';
import 'package:video_player/video_player.dart';
import 'package:voice_message_package/voice_message_package.dart';

import 'message_video_player.dart';

bool containsUrl(String input) {
  const urlPattern = r'(http|https):\/\/([\w.]+\/?)\S*';
  final regex = RegExp(urlPattern, caseSensitive: false);
  return regex.hasMatch(input);
}

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
  }) : super(key: key);
  final String message;
  final String date;

  @override
  Widget build(BuildContext context) {
    print(message);
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
          minWidth: 30,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: mainColor,
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
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontFamily: 'Sans-serif'),
                                  ),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 8,
                    fontFamily: 'Sans-serif',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SenderImageCard extends StatefulWidget {
//   final String url;
//   final String date;
//   final String imageName;

//   const SenderImageCard(
//       {Key? key,
//       required this.url,
//       required this.date,
//       required this.imageName})
//       : super(key: key);

//   @override
//   State<SenderImageCard> createState() => _SenderImageCardState();
// }

// class _SenderImageCardState extends State<SenderImageCard> {
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
//       alignment: Alignment.centerLeft,
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width - 40,
//           maxHeight: MediaQuery.of(context).size.width * 0.8,
//         ),
//         child: Card(
//           elevation: 1,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           color: main_color,
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
//                         color: Colors.white,
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

// class SenderPDFCard extends StatefulWidget {
//   final String url;
//   final String date;
//   final String pdfName;

//   const SenderPDFCard({
//     Key? key,
//     required this.url,
//     required this.date,
//     required this.pdfName,
//   }) : super(key: key);

//   @override
//   _SenderPDFCardState createState() => _SenderPDFCardState();
// }

// class _SenderPDFCardState extends State<SenderPDFCard> {
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
//       child: Align(
//         alignment: Alignment.centerLeft,
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
//             color: main_color,
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
//                             child: Container()
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
//                       color: Colors.white,
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

// class SenderVideoCard extends StatefulWidget {
//   final String videoUrl;
//   final String date;
//   final String imageName;
//   const SenderVideoCard(
//       {Key? key,
//       required this.imageName,
//       required this.videoUrl,
//       required this.date})
//       : super(key: key);

//   @override
//   State<SenderVideoCard> createState() => _SenderVideoCardState();
// }

// class _SenderVideoCardState extends State<SenderVideoCard> {
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
//       alignment: Alignment.centerLeft,
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width - 40,
//           maxHeight: MediaQuery.of(context).size.width * 0.8,
//         ),
//         child: Card(
//           elevation: 1,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           color: main_color,
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
//                 child: Text(
//                   widget.date,
//                   style: TextStyle(
//                     fontSize: 8,
//                     fontFamily: 'Sans-serif',
//                     fontWeight: FontWeight.w400,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
