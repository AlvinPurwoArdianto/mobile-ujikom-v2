import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor:
          HexColor("#4070f4"), // Background color like the blue in your HTML
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Lottie.asset(
                'assets/lottie/fabas-unscreen.json',
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            // Login Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header Title - Login
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color:
                            HexColor("#232836"), // Dark text color for header
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email Input Field
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Email Anda!',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: HexColor("#CACACA")),
                        ),
                        prefixIcon:
                            Icon(Icons.email, color: HexColor("#34a1eb")),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Password Input Field
                    TextField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Password Anda!',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: HexColor("#CACACA")),
                        ),
                        prefixIcon:
                            Icon(Icons.lock, color: HexColor("#34a1eb")),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.loginNow();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor("#0171d3"),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
