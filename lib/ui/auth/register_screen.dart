import 'package:bluebus/shared/mcolors.dart';
import 'package:bluebus/shared/mtext.dart';
import 'package:bluebus/shared/sbox.dart';
import 'package:bluebus/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailCtr = TextEditingController();
  var pwCtr = TextEditingController();
  var confPWCtr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPW = false;
  bool showConfPW = false;

  @override
  void dispose() {
    emailCtr.dispose();
    pwCtr.dispose();
    confPWCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MColors.background,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/regis_img.jpg",
                    height: 200,
                  ),
                  const SBox(height: 20, width: 0),
                  const MText(
                    content: "Chào mừng bạn!",
                    size: 35,
                    bold: true,
                    italic: false,
                  ),
                  const SBox(height: 20, width: 0),
                  loginForm(),
                  const SBox(height: 20, width: 0),
                  Row(
                    children: [
                      const MText(
                        content: "Đã có tài khoản?  ",
                        size: 17,
                        bold: false,
                        italic: true,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(
                            color: MColors.primary,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SBox(height: 30, width: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailCtr,
            obscureText: false,
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
                hintText: "Email",
                hintStyle: const TextStyle(
                  fontSize: 17,
                ),
                prefixIcon: const Icon(
                  Icons.email,
                  color: MColors.primary,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      emailCtr.text = "";
                    });
                  },
                  child: const Icon(
                    Icons.clear,
                    color: MColors.secondary,
                  ),
                ),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: MColors.primary),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: MColors.primaryContainer),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: MColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: MColors.error),
                ),
                filled: true,
                fillColor: MColors.primaryContainer),
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng nhập email";
              }
              if (!value.contains("@") || !value.contains(".")) {
                return "Hãy nhập email hợp lệ";
              }
              return null;
            },
          ),
          const SBox(height: 15, width: 0),
          TextFormField(
            controller: pwCtr,
            obscureText: !showPW,
            style: const TextStyle(
              fontSize: 18,
            ),
            maxLength: 16,
            decoration: InputDecoration(
                counterText: "",
                hintText: "Mật khẩu từ 8-16 ký tự",
                hintStyle: const TextStyle(
                  fontSize: 17,
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: MColors.primary,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      showPW = !showPW;
                    });
                  },
                  child: Icon(
                    !showPW ? Icons.visibility : Icons.visibility_off,
                    color: MColors.secondary,
                  ),
                ),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: MColors.primary),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: MColors.primaryContainer),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: MColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: MColors.error),
                ),
                filled: true,
                fillColor: MColors.primaryContainer),
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng nhập mật khẩu";
              }
              if (value.length < 8 || value.length > 16) {
                return "Mật khẩu phải từ 8-16 ký tự";
              }
              return null;
            },
          ),
          const SBox(height: 15, width: 0),
          TextFormField(
            controller: confPWCtr,
            obscureText: !showConfPW,
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
                hintText: "Nhập lại mật khẩu",
                hintStyle: const TextStyle(
                  fontSize: 17,
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: MColors.primary,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      showConfPW = !showConfPW;
                    });
                  },
                  child: Icon(
                    !showPW ? Icons.visibility : Icons.visibility_off,
                    color: MColors.secondary,
                  ),
                ),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: MColors.primary),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: MColors.primaryContainer),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: MColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: MColors.error),
                ),
                filled: true,
                fillColor: MColors.primaryContainer),
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng nhập lại mật khẩu";
              }
              if (value != pwCtr.text) {
                return "Mật khẩu không trùng khớp";
              }
              return null;
            },
          ),
          const SBox(height: 25, width: 0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {}
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MColors.primary,
              foregroundColor: MColors.background,
              minimumSize: const Size.fromHeight(55),
            ),
            child: const MText(
                content: "Đăng ký", size: 20, bold: false, italic: false),
          )
        ],
      ),
    );
  }
}
