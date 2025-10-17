import 'package:electronic/core/switching_language_facilities/Language_Switch_Widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/authController.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthController _authController = Get.put(AuthController());

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // 🌐 Language Switch Button - Top Right
                  const Positioned(
                    top: 50,
                    right: 20,
                    child: LanguageSwitch(),
                  ),

                  // 🖼️ Top Illustration
                  Positioned(
                    top: 65,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/auth/auth1.png',
                        width: 366,
                        height: 292,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // 🧾 Form Section
                  Positioned(
                    top: 360.5,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo
                              Image.asset(
                                'assets/images/Group 290580.png',
                                width: 94.84,
                                height: 128.32,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 16),

                              // 🟢 Welcome Text
                              Text(
                                'welcome_back'.tr,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF09B782),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // 🟢 Subtitle
                              Text(
                                'enter_email'.tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF606060),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // 🟢 Email Input Field
                              Container(
                                width: 330,
                                margin: const EdgeInsets.only(top: 24),
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.email_outlined,
                                        color: Color(0xFF09B782)),
                                    hintText: 'email'.tr,
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF9E9E9E),
                                      fontSize: 14,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFE0E0E0)),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF09B782), width: 1.5),
                                    ),
                                    errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5),
                                    ),
                                    focusedErrorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5),
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
                              const SizedBox(height: 16),

                              // 🟢 Error Message
                              Obx(() {
                                if (_authController.errorMessage.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      _authController.errorMessage.value,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }),

                              const SizedBox(height: 16),

                              // 🟢 Continue Button
                              Obx(() {
                                return SizedBox(
                                  width: 330,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _authController.isLoading.value
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!.validate()) {
                                              await _authController
                                                  .registerUser(_emailController.text.trim());
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
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            'send_otp'.tr,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
