import "package:flutter/material.dart";
import "../../../common/utils/constants.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kSecondaryColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Login!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                style: const TextStyle(color: Colors.white), // Màu chữ của nội dung TextField
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white), // Màu chữ của label
                  prefixIcon: const Icon(Icons.email, color: Colors.white), // Icon màu trắng
                  filled: true, // Để bật màu nền
                  fillColor: Colors.white.withOpacity(0.1), // Màu nền với độ trong suốt
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white), // Viền màu trắng khi không focus
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white), // Viền màu trắng khi focus
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                obscureText: true, // Ẩn nội dung nhập
                style: const TextStyle(color: Colors.white), // Màu chữ của nội dung TextField
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white), // Màu chữ của label
                  prefixIcon: const Icon(Icons.lock, color: Colors.white), // Icon màu trắng
                  filled: true, // Để bật màu nền
                  fillColor: Colors.white.withOpacity(0.1), // Màu nền với độ trong suốt
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white), // Viền màu trắng khi không focus
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white), // Viền màu trắng khi focus
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // TODO: Thực hiện logic đăng nhập
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Create a New Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}