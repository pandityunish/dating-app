// import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ristey/assets/image.dart';
import 'package:ristey/storage/base_storage_repo.dart';

class StorageRepo extends BaseStorageRepo {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  // Future<void> uploadImage(CroppedFile image) async {}

  Future<void> replaceImage(CroppedFile image1, int num) async {
    try {
      // print(image.path);
      // print(image.name);
      final cloudinary = CloudinaryPublic("dfkxcafte", "jhr5a7vo");
      CloudinaryResponse response = await cloudinary
          .uploadFile(CloudinaryFile.fromFile(image1.path, folder: "user"));
      String imageurl = response.secureUrl;
      ImageUrls().replaceLink(num, imageurl: imageurl);
      // int time = DateTime.now().millisecondsSinceEpoch;
      // String fileName = time.toString();
      // await storage
      //     .ref('Images/${fileName}')
      //     .putFile(File(image1.path))
      //     .then((p0) => DatabaseRepo().replaceUserPicture(fileName, num));
    } catch (err) {
      print("Erron   : ");
      print(err);
    }
  }

  Future<void> uploadImage(
    CroppedFile image1,
  ) async {
    try {
      final cloudinary = CloudinaryPublic("dfkxcafte", "jhr5a7vo");
      print(cloudinary);
      CloudinaryResponse response = await cloudinary
          .uploadFile(CloudinaryFile.fromFile(image1.path, folder: "user"));
      String imageurl = response.secureUrl;
      print(response.data);

      ImageUrls().add(
        imageurl: imageurl,
      );
    } catch (err) {

      print(err);
    }
  }

  @override
  Future<String> getDownloadurl(String imageName) async {
    String downloadUrl =
        await storage.ref('Images/$imageName').getDownloadURL();
    return downloadUrl;
  }
}
