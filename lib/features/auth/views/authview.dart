import 'package:electronic/core/switching_language_facilities/Language_Switch_Widget.dart';
import '../controllers/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';


class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.put(AuthController());

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      body: Column(
        children: [
          // Top Section with Image and Language Switch - 35% of screen height
          Container(
            height: screenHeight * 0.35,
            width: double.infinity,
            padding: EdgeInsets.only(top: screenHeight * 0.05),
            child: Stack(
              children: [
                // Language Switch Button - Top Right
                Positioned(
                  top: 0,
                  right: screenWidth * 0.05,
                  child: const LanguageSwitch(),
                ),
                // Top Illustration
                Center(
                  child: Image.asset(
                    'assets/auth/auth1.png',
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.25,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // Form Section - 65% of screen height
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/sundor logo.png',
                      width: screenWidth * 0.25,
                      height: screenHeight * 0.12,
                      fit: BoxFit.contain,
                    ),

                    // Title and Subtitle Section
                    Column(
                      children: [
                        Text(
                          'sign_up'.tr,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: const Color(0xFF09B782),
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'enter_email'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: const Color(0xFF606060),
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    // Email Field
                    Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => _authController.errorMessage.value = '',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: screenHeight * 0.02,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF09B782),
                          ),
                          hintText: 'email'.tr,
                          hintStyle: TextStyle(
                            color: const Color(0xFF9E9E9E),
                            fontSize: screenHeight * 0.018,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF09B782), width: 1.5),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1.5),
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'email_required'.tr;
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'invalid_email'.tr;
                          }
                          return null;
                        },
                      ),
                    ),

                    // Error Message
                    Obx(() {
                      if (_authController.errorMessage.isNotEmpty) {
                        return Text(
                          _authController.errorMessage.value,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // Sign Up Button
                    Obx(() {
                      return SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: _authController.isLoading.value
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _authController.registerUser(
                                      _emailController.text,
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF09B782),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: _authController.isLoading.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'continue'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenHeight * 0.02,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                        ),
                      );
                    }),

                    // Sign In Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "already_have_account".tr,
                          style: TextStyle(
                            color: const Color(0xFF606060),
                            fontFamily: 'Poppins',
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.authSignIn);
                          },
                          child: Text(
                            "sign_in".tr,
                            style: TextStyle(
                              color: const Color(0xFF09B782),
                              fontSize: screenHeight * 0.018,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
