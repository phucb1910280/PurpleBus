import 'package:bluebus/models/user.dart';
import 'package:bluebus/shared/mcolors.dart';
import 'package:bluebus/shared/mtext.dart';
import 'package:bluebus/shared/navigator.dart';
import 'package:bluebus/shared/sbox.dart';
import 'package:bluebus/ui/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future addUserDetail(
      String fullName, String phoneNumber, String email, String address) async {
    final CollectionReference userRef =
        FirebaseFirestore.instance.collection('Users');
    var user = Users(
      fullName: fullName,
      address: address,
      email: email,
      phoneNumber: phoneNumber,
      registerDay: DateTime.now(),
      profilePhoto:
          "https://firebasestorage.googleapis.com/v0/b/purplebus-ee57f.appspot.com/o/default_avatar.png?alt=media&token=14653759-47ca-4964-995d-63c0f628e84d&_gl=1*1xdiu81*_ga*NjgzODM5Njg5LjE2ODQ4OTgwNTA.*_ga_CW55HF8NVT*MTY5NjE3NzMzNS4yOS4xLjE2OTYxNzczNDcuNDguMC4w",
    );
    Map<String, dynamic> userData = user.toJson();
    await userRef.doc(email).set(userData);
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
            maxLength: 50,
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
                counterText: "",
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
              if (!value.contains("@") || !value.contains(".com")) {
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
              fillColor: MColors.primaryContainer,
            ),
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
            maxLength: 16,
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
              counterText: "",
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
              fillColor: MColors.primaryContainer,
            ),
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailCtr.text.trim(), password: pwCtr.text.trim());
                  addUserDetail("", "", emailCtr.text.trim(), "");
                  if (FirebaseAuth.instance.currentUser != null) {
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavigatorRoute()),
                        (route) => false,
                      );
                    }
                  }
                } catch (e) {
                  debugPrint(
                    e.toString(),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MColors.primary,
              foregroundColor: MColors.background,
              minimumSize: const Size.fromHeight(55),
            ),
            child: const MText(
              content: "Đăng ký",
              size: 20,
              bold: false,
              italic: false,
            ),
          )
        ],
      ),
    );
  }
}
