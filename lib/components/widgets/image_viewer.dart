import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:photo_view/photo_view_gallery.dart';
import 'package:untitled/components/widgets/send_claim.dart';
import 'package:untitled/components/widgets/video_player.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class ImageGalleryViewerScreen extends StatefulWidget {
  late List<String> galleryItems;
  late int startPage;
  late int? photoOwnerId;

  ImageGalleryViewerScreen(this.galleryItems,
      {this.startPage = 0, int? photoOwnerId}) {
    this.photoOwnerId = photoOwnerId;
  }

  @override
  State<ImageGalleryViewerScreen> createState() =>
      _ImageGalleryViewerScreenState();
}

class _ImageGalleryViewerScreenState extends State<ImageGalleryViewerScreen> {
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: widget.startPage);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          height: 72 + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 8, right: 8),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: const Color.fromARGB(255, 218, 216, 215),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                ),
                child: IconButton(
                    iconSize: 18.0,
                    color: Colors.white,
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.arrow_back_ios_sharp),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: const Color.fromARGB(255, 218, 216, 215),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                ),
                child: buildPopupMenuButton(),
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          loadingBuilder:
              (BuildContext context, ImageChunkEvent? loadingProgress) {
            return const Center(
              child: SizedBox(
                height: 64,
                width: 64,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          },
          builder: (BuildContext context, int index) {
            if (widget.galleryItems[index].contains(".avi") ||
                widget.galleryItems[index].contains(".mp4") ||
                widget.galleryItems[index].contains(".mov")) {
              return PhotoViewGalleryPageOptions.customChild(
                  child: VideoPlayerScreen(
                widget.galleryItems[index],
                photoOwnerId: 0,
              ));
            }
            return PhotoViewGalleryPageOptions(
              imageProvider: getImage(widget.galleryItems[index]),
              initialScale: PhotoViewComputedScale.contained * 1,
              minScale: PhotoViewComputedScale.contained * 1,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          itemCount: widget.galleryItems.length,
          pageController: controller,
        ),
      ),
      //body: Center(
      //  child: PhotoViewGallery(
      //      scrollPhysics: const BouncingScrollPhysics(),
      //      loadingBuilder: (BuildContext context, ImageChunkEvent? loadingProgress) {
      //        return const Center(
      //          child: SizedBox(
      //            height: 64,
      //            width: 64,
      //            child: CircularProgressIndicator(
      //              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      //            ),
      //          ),
      //        );
      //      },
      //      pageOptions: List.generate(widget.galleryItems.length, (index) {
      //        if(widget.galleryItems[index].contains(".avi")
      //        || widget.galleryItems[index].contains(".mp4")
      //        || widget.galleryItems[index].contains(".mov"))
      //        {
      //          return  PhotoViewGalleryPageOptions.customChild(
      //              child: VideoPlayerScreen(widget.galleryItems[index], photoOwnerId: 0,)
      //          );
      //        }
      //        return PhotoViewGalleryPageOptions(
      //          imageProvider: getImage(widget.galleryItems[index]),
      //          initialScale: PhotoViewComputedScale.contained * 1,
      //          minScale: PhotoViewComputedScale.contained * 1,
      //          maxScale: PhotoViewComputedScale.covered * 2,
      //        );
      //      })
      //  ),
      //),
    );
  }

  Widget buildPopupMenuButton() {
    if (widget.photoOwnerId != null) {
      return PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          shape: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () async {
                    Future.delayed(
                        const Duration(seconds: 0),
                        () => SendClaim(
                            claimObjectId: widget.photoOwnerId!,
                            type: ClaimType.photo
                        ).ShowAlertDialog(this.context));
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.block),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        LocaleKeys.chat_report.tr(),
                      )
                    ],
                  ),
                ),
              ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}

ImageProvider getImage(String url) {
  try {
    final File imageFile =
        File('${appDir.path}/${url.substring(url.lastIndexOf('/') + 1)}');
    if (imageFile.existsSync() && (imageFile.lengthSync() != 0)) {
      return Image.file(imageFile, fit: BoxFit.cover).image;
    } else {
      return NetworkImage(url);
    }
  } catch (ex) {
    return NetworkImage(url);
  }
}

Widget displayPhotoOrVideo(BuildContext context, String url,
    {List<String>? items, int? initPage, int? photoOwnerId}) {
  return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ImageGalleryViewerScreen(
              items!.cast<String>(),
              startPage: initPage!,
              photoOwnerId: photoOwnerId,
            ),
            transitionDuration: const Duration(seconds: 0),
          ),
        );
      },
      child:
          (url.contains(".mp4") || url.contains(".avi") || url.contains(".mov"))
              ? const Icon(
                  Icons.slow_motion_video_outlined,
                  color: Colors.white,
                  size: 60,
                )
              : displayImageMiniature(url));
}

FutureBuilder displayImageMiniature(String url) {
  return FutureBuilder<Widget>(
    future: getImageFromUrl(url),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        return snapshot.data;
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
}

Future<Widget> getImageFromUrl(String url) async {
  try {

    if ((url.contains("http://") || url.contains("https://")) == false) {
      final File imageFile = File(url);
      return Image.file(
        imageFile,
        cacheHeight: 300,
        
      );
    }

    final Directory temp = await getTemporaryDirectory();
    String prefix = (url.contains("preview")) ? "/preview" : "";
    appDir = temp;
    final File imageFile =
        File('${temp.path}$prefix/${url.substring(url.lastIndexOf('/') + 1)}');

    if (imageFile.existsSync() && (imageFile.lengthSync() != 0)) {
      return Image.file(imageFile,
          cacheHeight: 700,
          //cacheWidth: 256,
          fit: BoxFit.cover,
         );
    } else {
      // Image doesn't exist in cache
      imageFile.create(recursive: true).then((value) => http
          .get(Uri.parse(url))
          .then((response) =>
              imageFile.writeAsBytes(response.bodyBytes, flush: true)));

      return Image.network(
        url,
        
        cacheHeight: 300,
        //cacheWidth: 256,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }
  } catch (err) {
    debugPrint("Can't save image/ Load from network");
    debugPrint(url);
    return Container();
  }
}

late Directory appDir;
