// File: lib/modules/profile/controllers/profile_info_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:electronic/routes/app_pages.dart';

class ProfileInfoController extends GetxController {
  // 🔹 Form key
  final formKey = GlobalKey<FormState>();

  // 🔹 Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();

  // 🔹 Reactive variables
  final selectedGender = ''.obs;
  final selectedDate = Rx<DateTime?>(null);
  final isLoading = false.obs;

  // 🔹 Gender options
  final List<String> genderOptions = [
    'male'.tr,
    'female'.tr,
    'other'.tr,
  ];

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

  // 🔹 Load sample data
  void _loadInitialData() {
    firstNameController.text = 'Asad';
    lastNameController.text = 'Ujjaman';
    selectedGender.value = 'male'.tr;
    selectedDate.value = DateTime(2024, 12, 17);
    addressController.text =
        '76/4 R no. 60/1 Rue des Saints-Paris, 75005 Paris';
  }

  // 🔹 Validation
  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'first_name_required'.tr;
    }
    if (value.trim().length < 2) {
      return 'first_name_min_length'.tr;
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'last_name_required'.tr;
    }
    if (value.trim().length < 2) {
      return 'last_name_min_length'.tr;
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'address_required'.tr;
    }
    if (value.trim().length < 10) {
      return 'address_min_length'.tr;
    }
    return null;
  }

  // 🔹 Date Picker
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

  // 🔹 Confirm Profile
  Future<void> confirmProfile() async {
    if (!formKey.currentState!.validate()) {
      Future.microtask(() {
        Get.snackbar(
          'validation_error'.tr,
          'fill_required_fields'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      });
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

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Future.microtask(() {
        Get.snackbar(
          'success'.tr,
          'profile_update_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      });

      Get.offAllNamed(Routes.home);
    } catch (error) {
      Future.microtask(() {
        Get.snackbar(
          'error'.tr,
          'update_failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      });
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Reset / Clear
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

  // 🔹 Change Tracker
  bool get hasChanges {
    return firstNameController.text.trim() != 'Asad' ||
        lastNameController.text.trim() != 'Ujjaman' ||
        selectedGender.value != 'male'.tr ||
        selectedDate.value != DateTime(2024, 12, 17) ||
        addressController.text.trim() !=
            '76/4 R no. 60/1 Rue des Saints-Paris, 75005 Paris';
  }

  // 🔹 Date Formatter
  String formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month]}, ${date.year}';
  }
}
