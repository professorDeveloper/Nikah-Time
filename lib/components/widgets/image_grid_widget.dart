import 'dart:io';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:untitled/components/widgets/image_viewer.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';




class PhotoPlace extends StatefulWidget{
  const PhotoPlace(this.userProfileData, this.callback, {super.key});

  final VoidCallback callback;
  final UserProfileData userProfileData;

  @override
  State<PhotoPlace> createState() => _PhotoPlaceState();
}

class _PhotoPlaceState extends State<PhotoPlace> {
  ImagePicker picker = ImagePicker();
  late int _itemCount;//
  int maxItemCount = 9;

  @override
  Widget build(BuildContext context) {
    _itemCount = widget.userProfileData.images?.length ?? 0;

    if (_itemCount == 0) {
      _itemCount = 1;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            showPhotoActions(0, true);
          },
          onLongPress: () async {
            showPhotoActions(0, true);
          },
          child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Color.fromRGBO(230, 230, 230, 1),
              ),
              width: double.infinity,
              height: 246,
              child: widget.userProfileData.hasMainPhoto() ? ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: displayPhotoOrVideo(
                    this.context,
                    widget.userProfileData.images![0].main.toString(),
                    items: widget.userProfileData.images!.map((e) => e.main).toList().cast<String>(),
                    initPage: 0,
                    photoOwnerId: widget.userProfileData.id
                ),
              ) : const Icon(Icons.photo_camera, color: Colors.white, size: 60,)
          ),
        ),
        SizedBox(
          height: ( 16 + MediaQuery.of(context).size.width / 3 * ((_itemCount) / 3).ceil()).toDouble(),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8
            ),
            physics: const  NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              index++;

              if(index > widget.userProfileData.getAdditionalPhotosLength())
              {
                return GestureDetector(
                  onTap: () async {
                    showPhotoActions(index, false);
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color.fromRGBO(230, 230, 230, 1),
                      ),
                      child: const Icon(Icons.photo_camera, color: Colors.white, size: 60,)
                  )
                );
              }

              return GestureDetector(
                onLongPress: () async {
                  showPhotoActions(index, false);
                },
                child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Color.fromRGBO(230, 230, 230, 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: displayPhotoOrVideo(
                        this.context,
                        widget.userProfileData.images![index].preview.toString(),
                        items: widget.userProfileData.images!.map((e) => e.main).toList().cast<String>(),
                        initPage: index,
                        photoOwnerId: widget.userProfileData.id
                      ),
                    )
                ),
              );
            },
            itemCount: widget.userProfileData.getAdditionalPhotosLength() + 1
          )
        )
      ],
    );
  }


  void showPhotoActions(int index, bool main){
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: Text(LocaleKeys.common_takePhoto.tr()),
          onTap: () async {
            try{
              XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  preferredCameraDevice: CameraDevice.front
              );
              setState(() {
                sendProfileImageOrVideo(
                  File(image!.path),
                  "image", index
                );
                //_putNewUserInfo();
                if(_itemCount < maxItemCount)
                {
                  _itemCount++;
                }
              });
            }catch(err){
              debugPrint(err.toString());
            }
            widget.callback();
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_album),
          title: Text(LocaleKeys.common_getPhoto.tr()),
          onTap: () async {

            try{
              XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              setState(() {
                sendProfileImageOrVideo(
                    File(image!.path),
                    "image", index
                );
                //_putNewUserInfo();
                if(_itemCount < maxItemCount)
                {
                  _itemCount++;
                }
              });
            }
            catch(err){
              debugPrint(err.toString());
            }
            widget.callback();
            Navigator.pop(context);
          },
        ),
        Visibility(
            visible: !main,
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.videocam),
                  title: Text(LocaleKeys.common_takeVide.tr()),
                  onTap: () async {
                    try{
                      XFile? video = await picker.pickVideo(
                          source: ImageSource.camera
                      );
                      await sendProfileImageOrVideo(File(video!.path), "video", index);
                      if(_itemCount < maxItemCount)
                      {
                        _itemCount++;
                      }
                    }catch(err){
                      debugPrint(err.toString());
                    }
                    widget.callback();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.video_library),
                  title: Text(LocaleKeys.common_getVideo.tr()),
                  onTap: () async {
                    try{
                      XFile? video = await picker.pickVideo(
                        source: ImageSource.gallery,
                      );
                      sendProfileImageOrVideo(File(video!.path), "video", index);
                      if(_itemCount < maxItemCount)
                      {
                        _itemCount++;
                      }
                    }catch(err){
                      debugPrint(err.toString());
                    }
                    widget.callback();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(LocaleKeys.common_delete.tr()),
                  onTap: () async {
                    MyTracker.trackEvent("Delete photo from profile", {});
                    setState(() {
                      if(widget.userProfileData.images != null){
                        widget.userProfileData.images!.removeAt(index);
                      }
                      const Icon(Icons.add, color: Color.fromRGBO(230, 230, 230, 1), size: 60,);
                      if (_itemCount > 1) _itemCount--;
                      Navigator.pop(context);
                    });
                    widget.callback();
                  },
                ),
              ],
            )
        ),
      ]),
    );
  }

  Future<void> sendProfileImageOrVideo(File image, String fileType, int index) async {
    if ((fileType == "image" || fileType == "video") == false) {
      throw UnsupportedError("Method not support $fileType as fileType");
    }

    var response = await NetworkService().UploadFileRequest(
        widget.userProfileData.accessToken.toString(),
        image.path,
        fileType);
    debugPrint(response.statusCode.toString());
    if(response.statusCode != 200){
      return;
    }
    try{
      widget.userProfileData.images ??= <UserProfileImage>[];
      await response.stream.transform(utf8.decoder).listen((value) async {
        Map valueMap = json.decode(value.toString());
        debugPrint(valueMap.toString());
        debugPrint(index.toString());
        if (index != 0) {
          if (fileType == "image") {
            final photo = UserProfileImage.fromJson(valueMap["photos"][0]);
            widget.userProfileData.images!.add(photo);
          } else if (fileType == "video") {
            final videoLink = valueMap["fileURL"];
            widget.userProfileData.images!.add(UserProfileImage(
                main: videoLink,
                preview: videoLink
            ));
            widget.userProfileData.photos!.add(videoLink);
          }
        } else {
          if (widget.userProfileData.images!.isEmpty) {
            widget.userProfileData.images!.add(UserProfileImage(preview: "", main: ""));
          }
          if (fileType == "image") {
            final photo = UserProfileImage.fromJson(valueMap["photos"][0]);
            widget.userProfileData.images![index] = photo;
          } else if (fileType == "video") {
            final videoLink = valueMap["fileURL"];
            widget.userProfileData.images![index] = UserProfileImage(
                main: videoLink,
                preview: videoLink
            );
          }
        }
      });
    } catch(error){
      debugPrint("Err: $error");
    }

    setState(() {});
  }

}