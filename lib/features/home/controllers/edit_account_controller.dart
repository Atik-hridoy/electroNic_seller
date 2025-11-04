import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_urls.dart';
import '../views/account/model/update_profile_model.dart';
import '../views/account/services/update_profile_service.dart';
import '../views/account/services/get_profile_service.dart';

class EditAccountController extends GetxController {
  // Services
  final UpdateProfileServiceInsideApp _profileService = UpdateProfileServiceInsideApp();
  final GetProfileService _getProfileService = GetProfileService();
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // User profile data
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString address = ''.obs;
  final RxString gender = ''.obs;
  final RxString registrationNo = ''.obs;
  final RxString dateOfBirth = ''.obs;
  final RxString password = '••••••••'.obs;
  
  // Profile image
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString profileImageUrl = ''.obs;
  final ImagePicker _imagePicker = ImagePicker();

  // Form controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      final profileData = await _getProfileService.getProfile();
      
      if (profileData != null) {
        // Update reactive variables with profile data
        fullName.value = '${profileData.data.firstName} ${profileData.data.lastName}';
        gender.value = profileData.data.gender;
        address.value = profileData.data.address;
        registrationNo.value = profileData.data.registrationNo;
        phone.value = profileData.data.phone;
        
        // Update profile image URL from backend
        if (profileData.data.profileImage != null && profileData.data.profileImage!.isNotEmpty) {
          profileImageUrl.value = _buildImageUrl(profileData.data.profileImage!);
        }
        
        // Update form controllers
        fullNameController.text = profileData.data.firstName;
        lastNameController.text = profileData.data.lastName;
        genderController.text = profileData.data.gender;
        addressController.text = profileData.data.address;
        phoneController.text = profileData.data.phone;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      
      // Create the profile model from form data
      final profileData = UpdateProfileModel(
        firstName: fullNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: genderController.text.trim().toLowerCase(),
        address: addressController.text.trim(),
        phone: phoneController.text.trim(),
      );

      // Call the update service without image (image uploaded separately)
      final response = await _profileService.updateProfileInsideApp(
        profileData: profileData,
      );

      if (response['success'] == true) {
        // Update local state on success
        fullName.value = '${profileData.firstName} ${profileData.lastName}';
        phone.value = phoneController.text.trim();
        address.value = addressController.text.trim();
        gender.value = genderController.text.trim();
        
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[800],
        );
        
        // Optionally navigate back
        Get.back();
      } else {
        throw Exception(response['error'] ?? 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updatePassword(String newPassword) {
    if (newPassword.length >= 8) {
      password.value = '•' * 8; // Mask password

      Get.snackbar(
        'Success',
        'Password updated successfully',
        backgroundColor: Colors.green[50],
        colorText: Colors.green[800],
      );
    } else {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters long',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    }
  }

  /// Pick image from gallery or camera
  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        
        // Automatically upload the image
        await uploadProfileImage();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    }
  }

  // Helper method to build full image URL
  String _buildImageUrl(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // Already a full URL
      return imagePath;
    } else {
      // Relative path, combine with base URL
      return '${AppUrls.imageBaseUrl}$imagePath';
    }
  }

  /// Show image source selection dialog
  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImage(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImage(source: ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Upload profile image to server
  Future<void> uploadProfileImage() async {
    if (profileImage.value == null) {
      Get.snackbar(
        'Error',
        'Please select an image first',
        backgroundColor: Colors.orange[50],
        colorText: Colors.orange[800],
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // Create profile data with current values
      final profileData = UpdateProfileModel(
        firstName: fullNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: genderController.text.trim().toLowerCase(),
        address: addressController.text.trim(),
        phone: phoneController.text.trim(),
      );

      // Call the update service with image
      final response = await _profileService.updateProfileInsideApp(
        profileData: profileData,
        profileImage: profileImage.value,
      );

      if (response['success'] == true) {
        // Clear local image so network image will be shown
        profileImage.value = null;
        
        Get.snackbar(
          'Success',
          'Profile image updated successfully',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[800],
        );
        
        // Refresh profile data to get updated image URL from backend
        await fetchProfileData();
      } else {
        throw Exception(response['error'] ?? 'Failed to upload image');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: ${e.toString().replaceAll("Exception: ", "")}',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    genderController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
