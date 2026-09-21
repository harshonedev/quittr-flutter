import 'package:image_picker/image_picker.dart';

abstract class ImagePickerService {
  Future<String?> pickImage(ImageSource source);
}

class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker;

  ImagePickerServiceImpl({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  @override
  Future<String?> pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      return image?.path;
    } catch (e) {
      return null;
    }
  }
}
