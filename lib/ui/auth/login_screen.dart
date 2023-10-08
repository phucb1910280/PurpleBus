import 'package:bluebus/shared/mcolors.dart';
import 'package:bluebus/shared/mtext.dart';
import 'package:bluebus/shared/navigator.dart';
import 'package:bluebus/shared/sbox.dart';
import 'package:bluebus/ui/auth/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailCtr = TextEditingController();
  var pwCtr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPW = false;

  @override
  void dispose() {
    emailCtr.dispose();
    pwCtr.dispose();
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
                  const SBox(height: 20, width: 0),
                  Image.asset(
                    "assets/images/login_img.jpg",
                    height: 200,
                  ),
                  const SBox(height: 20, width: 0),
                  const MText(
                      content: "Xin chào!",
                      size: 40,
                      bold: true,
                      italic: false),
                  const SBox(height: 10, width: 0),
                  const MText(
                    content: "Điền email và mật khẩu để đăng nhập",
                    size: 18,
                    bold: false,
                    italic: false,
                  ),
                  const SBox(height: 30, width: 0),
                  loginForm(),
                  SizedBox(
                    height: 30,
                    width: 200,
                    child: Divider(
                      color: MColors.primary.withOpacity(.5),
                    ),
                  ),
                  Row(
                    children: [
                      const MText(
                        content: "Chưa có tài khoản?  ",
                        size: 17,
                        bold: false,
                        italic: true,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Đăng ký",
                          style: TextStyle(
                            color: MColors.primary,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SBox(height: 20, width: 0),
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
              fillColor: MColors.primaryContainer,
            ),
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
            decoration: InputDecoration(
                hintText: "Mật khẩu",
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
              return null;
            },
          ),
          const SBox(height: 25, width: 0),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailCtr.text.trim(), password: pwCtr.text.trim());
                  if (FirebaseAuth.instance.currentUser != null) {
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigatorRoute(),
                        ),
                        (route) => false,
                      );
                    }
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MColors.primary,
              foregroundColor: MColors.background,
              minimumSize: const Size.fromHeight(55),
            ),
            child: const MText(
                content: "Đăng nhập", size: 20, bold: false, italic: false),
          )
        ],
      ),
    );
  }
}
