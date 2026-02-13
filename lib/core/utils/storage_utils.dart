import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class StorageUtils {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery
  static Future<File?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        // imageQuality: 70, // REMOVED: Causes errors on some iOS versions
      );
      if (image != null) {
        final originalFile = File(image.path);
        // Compress before returning
        return await _compressImage(originalFile);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Compress image using flutter_image_compress
  static Future<File> _compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80, // High quality but optimized size
        minWidth: 1024, // Reasonable max width for mobile
        minHeight: 1024,
      );

      return result != null ? File(result.path) : file;
    } catch (e) {
      print('Compression error: $e');
      return file; // Return original if compression fails
    }
  }

  /// Upload file to Firebase Storage and return download URL
  static Future<String?> uploadFile(File file, String folder) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      final Reference ref = _storage.ref().child(folder).child(fileName);
      
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  /// Upload multiple files
  static Future<List<String>> uploadMultipleFiles(List<File> files, String folder) async {
    List<String> urls = [];
    for (var file in files) {
      final url = await uploadFile(file, folder);
      if (url != null) urls.add(url);
    }
    return urls;
  }
}
