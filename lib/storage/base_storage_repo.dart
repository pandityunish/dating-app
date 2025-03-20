import 'package:image_cropper/image_cropper.dart';

abstract class BaseStorageRepo {
  // Future<void>uploadImage(XFile image);
  Future<void> uploadImage(CroppedFile image1);
  Future<String> getDownloadurl(String imageName);
}
