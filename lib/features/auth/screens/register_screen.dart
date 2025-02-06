import "package:flutter/material.dart";
import "../../../common/utils/constants.dart";
import "../widgets/custom_text_form_field.dart";
import "../../../common/widgets/custom_elevated_button.dart";
import "../services/auth_service.dart";
import "../../../repositories/user_repository.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers cho các trường nhập liệu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();

  bool _isLoading = false; // Trạng thái đang xử lý

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Hàm xử lý khi nhấn "Register"
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final user = await _authService.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        Navigator.pushNamed(context, "/login");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kSecondaryColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Register!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Trường nhập Name
                CustomTextFormField(
                  controller: _nameController,
                  labelText: "Name",
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return "Name is required!";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Trường nhập email
                CustomTextFormField(
                  controller: _emailController,
                  labelText: "Email",
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return "Email is required!";
                    }
                    final emailRegex = RegExp(
                        r'^[a-z|0-9|A-Z]*([_][a-z|0-9|A-Z]+)*([.][a-z|0-9|A-Z]+)*([.][a-z|0-9|A-Z]+)*(([_][a-z|0-9|A-Z]+)*)?@[a-z][a-z|0-9|A-Z]*\.([a-z][a-z|0-9|A-Z]*(\.[a-z][a-z|0-9|A-Z]*)?)$'); // Kiểm tra email hợp lệ
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Trường nhập Password
                CustomTextFormField(
                  controller: _passwordController,
                  labelText: "Password",
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return "Password is required!";
                    }
                    if(value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Trường nhập Confirm Password
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  labelText: "Confirm Password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return "Confirm password is required!";
                    }
                    if(value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Nút Register
                CustomElevatedButton(
                  isLoading: _isLoading,
                  onPressed: _register,
                  text: 'Register',
                ),

                const SizedBox(height: 20),

                // Text chuyển đến Login
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
