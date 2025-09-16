import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:electronic/routes/app_pages.dart';

class ProfileInfoController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();

  // Observable variables
  final selectedGender = ''.obs;
  final selectedDate = Rx<DateTime?>(null);
  final isLoading = false.obs;

  // Gender options
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void _loadInitialData() {
    firstNameController.text = 'Asad';
    lastNameController.text = 'Ujjaman';
    selectedGender.value = 'Male';
    selectedDate.value = DateTime(2024, 12, 17);
    addressController.text = '76/4 R no. 60/1 Rue des Saints-Paris, 75005 Paris';
  }

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().length < 10) {
      return 'Please enter a complete address';
    }
    return null;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal.shade600,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> confirmProfile() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isLoading.value = true;

      final profileData = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'gender': selectedGender.value,
        'lastUpdate': selectedDate.value?.toIso8601String(),
        'address': addressController.text.trim(),
      };

      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Profile information updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate to Home after successful confirmation
      Get.offAllNamed(Routes.home);

    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to update profile information. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
    selectedGender.value = '';
    selectedDate.value = null;
  }

  void resetForm() {
    _loadInitialData();
  }

  bool get hasChanges {
    return firstNameController.text.trim() != 'Asad' ||
        lastNameController.text.trim() != 'Ujjaman' ||
        selectedGender.value != 'Male' ||
        selectedDate.value != DateTime(2024, 12, 17) ||
        addressController.text.trim() != '76/4 R no. 60/1 Rue des Saints-Paris, 75005 Paris';
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month]}, ${date.year}';
  }
}