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
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
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

                              // 🟢 Sign In Title
                              Text(
                                'sign_in'.tr,
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
                                'enter_email_to_continue'.tr,
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

                              // 🟢 Email Field
                              Container(
                                width: 330,
                                margin: const EdgeInsets.only(top: 24),
                                child: TextFormField(
                                  controller: _authSignInController.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (_) => _authSignInController.clearError(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF09B782),
                                    ),
                                    hintText: 'email'.tr,
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF9E9E9E),
                                      fontSize: 14,
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
                              const SizedBox(height: 16),

                              // 🟢 Error Message
                              Obx(() {
                                if (_authSignInController.errorMessage.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      _authSignInController.errorMessage.value,
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

                              // 🟢 Sign In Button
                              Obx(() {
                                return SizedBox(
                                  width: 330,
                                  height: 50,
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

                              const SizedBox(height: 20),

                              // 🟢 Sign Up Redirect
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "dont_have_account".tr,
                                    style: const TextStyle(
                                      color: Color(0xFF606060),
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.auth);
                                    },
                                    child: Text(
                                      "sign_up".tr,
                                      style: const TextStyle(
                                        color: Color(0xFF09B782),
                                        fontSize: 16,
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
