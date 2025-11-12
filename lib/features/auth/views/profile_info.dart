import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_info_controller.dart';

class ProfileInfoView extends GetView<ProfileInfoController> {
  const ProfileInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section - flexible height
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: _buildHeader(screenHeight, screenWidth),
            ),
            
            // Form Section - takes remaining space
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: _buildForm(screenHeight, screenWidth),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenHeight, double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'profile_information'.tr,
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade600,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'confirm_real_info'.tr,
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(double screenHeight, double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFirstNameField(screenHeight, screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildLastNameField(screenHeight, screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildGenderField(screenHeight, screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildAddressField(screenHeight, screenWidth),
            SizedBox(height: screenHeight * 0.03),
            _buildConfirmButton(screenHeight, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, double screenHeight) {
    return Text(
      text.endsWith('*') 
          ? '${text.substring(0, text.length - 1)}*'.tr 
          : text.tr,
      style: TextStyle(
        fontSize: screenHeight * 0.018,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required double screenHeight,
    required double screenWidth,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(
        fontSize: screenHeight * 0.02,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText.tr,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: screenHeight * 0.018,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.teal.shade300, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, 
          vertical: screenHeight * 0.015
        ),
      ),
    );
  }

  Widget _buildFirstNameField(double screenHeight, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('first_name', screenHeight),
        SizedBox(height: screenHeight * 0.01),
        _buildTextField(
          controller: controller.firstNameController,
          hintText: 'John',
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          validator: controller.validateFirstName,
        ),
      ],
    );
  }

  Widget _buildLastNameField(double screenHeight, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('last_name', screenHeight),
        SizedBox(height: screenHeight * 0.01),
        _buildTextField(
          controller: controller.lastNameController,
          hintText: 'Doe',
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          validator: controller.validateLastName,
        ),
      ],
    );
  }

  Widget _buildGenderField(double screenHeight, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('gender', screenHeight),
        SizedBox(height: screenHeight * 0.01),
        Obx(() => _buildDropdown(
          value: controller.selectedGender.value.isNotEmpty
              ? controller.selectedGender.value
              : null,
          items: controller.genderOptions,
          onChanged: (value) => controller.selectedGender.value = value ?? '',
          hintText: 'Select Gender'.tr,
          screenHeight: screenHeight,
          screenWidth: screenWidth,
        )),
      ],
    );
  }

  Widget _buildAddressField(double screenHeight, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('address', screenHeight),
        SizedBox(height: screenHeight * 0.01),
        _buildTextField(
          controller: controller.addressController,
          hintText: 'enter_full_address'.tr,
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          maxLines: 3,
          validator: controller.validateAddress,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hintText,
    required double screenHeight,
    required double screenWidth,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.005,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hintText,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: screenHeight * 0.018,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item.tr,
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildConfirmButton(double screenHeight, double screenWidth) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.06,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: controller.isLoading.value
            ? SizedBox(
                width: screenWidth * 0.05,
                height: screenWidth * 0.05,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'confirm'.tr,
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      )),
    );
  }
}
