import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_signIn_controller.dart';
import '../../../routes/app_pages.dart';

class AuthSignInView extends StatefulWidget {
  const AuthSignInView({super.key});

  @override
  State<AuthSignInView> createState() => _AuthSignInViewState();
}

class _AuthSignInViewState extends State<AuthSignInView> {
  final _formKey = GlobalKey<FormState>();
  final AuthSignInController _authSignInController = Get.put(AuthSignInController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      body: Column(
        children: [
          // 🖼️ Top Illustration - 35% of screen height
          Container(
            height: screenHeight * 0.35,
            width: double.infinity,
            padding: EdgeInsets.only(top: screenHeight * 0.05),
            child: Center(
              child: Image.asset(
                'assets/auth/auth1.png',
                width: screenWidth * 0.8,
                height: screenHeight * 0.25,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 🧾 Form Section - 65% of screen height
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
                      'assets/images/Group 290580.png',
                      width: screenWidth * 0.25,
                      height: screenHeight * 0.12,
                      fit: BoxFit.contain,
                    ),

                    // Title and Subtitle Section
                    Column(
                      children: [
                        Text(
                          'sign_in'.tr,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: const Color(0xFF09B782),
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'enter_email_to_continue'.tr,
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
                        controller: _authSignInController.emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => _authSignInController.clearError(),
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
                      if (_authSignInController.errorMessage.isNotEmpty) {
                        return Text(
                          _authSignInController.errorMessage.value,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // Sign In Button
                    Obx(() {
                      return SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: _authSignInController.isLoading.value
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _authSignInController.signIn(
                                      email: _authSignInController.emailController.text);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF09B782),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: _authSignInController.isLoading.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'send_otp'.tr,
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

                    // Sign Up Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "dont_have_account".tr,
                          style: TextStyle(
                            color: const Color(0xFF606060),
                            fontFamily: 'Poppins',
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.auth);
                          },
                          child: Text(
                            "sign_up".tr,
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
