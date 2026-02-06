import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ⭐ GET YOUR FREE API KEY FROM: https://api.imgbb.com/
  // 1. Go to https://api.imgbb.com/
  // 2. Click "Get API Key"
  // 3. Sign up (30 seconds)
  // 4. Copy your API key and paste below
  static const String IMGBB_API_KEY = '5016b0f018e5d398175aafd11fe2e726';
  static const String IMGBB_UPLOAD_URL = 'https://api.imgbb.com/1/upload';

  // ============================================
  // COMPRESS IMAGE
  // ============================================
  Future<File?> _compressImage(File file) async {
    try {
      final String targetPath = file.path.replaceAll('.jpg', '_compressed.jpg');

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70, // 70% quality (good balance)
        minWidth: 1024,
        minHeight: 1024,
      );

      return result != null ? File(result.path) : file;
    } catch (e) {
      print('Compression error: $e');
      return file; // Return original if compression fails
    }
  }

  // ============================================
  // UPLOAD TO IMGBB (FREE API)
  // ============================================
  Future<String> _uploadToImgBB(File imageFile) async {
    try {
      // Compress image first
      File? compressedImage = await _compressImage(imageFile);

      // Read file as bytes
      List<int> imageBytes = await (compressedImage ?? imageFile).readAsBytes();

      // Convert to base64
      String base64Image = base64Encode(imageBytes);

      // Upload to ImgBB
      final response = await http.post(
        Uri.parse(IMGBB_UPLOAD_URL),
        body: {
          'key': IMGBB_API_KEY,
          'image': base64Image,
          'expiration': '0', // 0 = Never expire (permanent)
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          String imageUrl = data['data']['url'];
          print('✅ Image uploaded successfully: $imageUrl');
          return imageUrl;
        } else {
          throw Exception('Upload failed: ${data['error']['message']}');
        }
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ImgBB upload error: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  // ============================================
  // UPLOAD PROFILE IMAGE
  // ============================================
  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // Upload to ImgBB (FREE!)
      String imageUrl = await _uploadToImgBB(imageFile);

      // Save URL to Firestore
      await _firestore.collection('users').doc(userId).update({
        'personalInfo.profilePhotoUrl': imageUrl,
      });

      print('✅ Profile image saved to Firestore');
      return imageUrl;
    } catch (e) {
      print('❌ Error uploading profile image: $e');
      throw Exception('Failed to upload profile image');
    }
  }

  // ============================================
  // UPLOAD PRESCRIPTION IMAGE
  // ============================================
  Future<String> uploadPrescriptionImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // Upload to ImgBB
      String imageUrl = await _uploadToImgBB(imageFile);

      // Save to prescriptions subcollection
      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('prescriptions')
          .add({
        'imageUrl': imageUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Prescription image saved: ${docRef.id}');
      return imageUrl;
    } catch (e) {
      print('❌ Error uploading prescription image: $e');
      throw Exception('Failed to upload prescription');
    }
  }

  // ============================================
  // PICK IMAGE FROM GALLERY
  // ============================================
  Future<File?> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70,
      );

      if (image != null) {
        print('✅ Image picked from gallery: ${image.path}');
        return File(image.path);
      }

      print('ℹ️ No image selected');
      return null;
    } catch (e) {
      print('❌ Error picking image: $e');
      return null;
    }
  }

  // ============================================
  // PICK IMAGE FROM CAMERA
  // ============================================
  Future<File?> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70,
      );

      if (image != null) {
        print('✅ Photo taken: ${image.path}');
        return File(image.path);
      }

      print('ℹ️ Camera cancelled');
      return null;
    } catch (e) {
      print('❌ Error taking photo: $e');
      return null;
    }
  }

  // ============================================
  // DELETE IMAGE (Optional - ImgBB free doesn't support deletion)
  // ============================================
  Future<void> deleteImage(String imageUrl) async {
    try {
      // Note: ImgBB free tier doesn't support image deletion via API
      // Images are permanent unless you upgrade to paid plan
      print('ℹ️ ImgBB free tier: Images are permanent and cannot be deleted via API');

      // You can still remove the URL from Firestore
      // The image will remain on ImgBB but won't be referenced in your app
    } catch (e) {
      print('❌ Error deleting image reference: $e');
    }
  }

  // ============================================
  // GET PRESCRIPTION IMAGES
  // ============================================
  Future<List<Map<String, dynamic>>> getPrescriptionImages(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('prescriptions')
          .orderBy('uploadedAt', descending: true)
          .get();

      List<Map<String, dynamic>> prescriptions = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        prescriptions.add(data);
      }

      return prescriptions;
    } catch (e) {
      print('❌ Error getting prescription images: $e');
      throw Exception('Failed to get prescriptions');
    }
  }

  // ============================================
  // DELETE PRESCRIPTION FROM FIRESTORE
  // ============================================
  Future<void> deletePrescription(String userId, String prescriptionId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('prescriptions')
          .doc(prescriptionId)
          .delete();

      print('✅ Prescription deleted from Firestore');
    } catch (e) {
      print('❌ Error deleting prescription: $e');
      throw Exception('Failed to delete prescription');
    }
  }
}