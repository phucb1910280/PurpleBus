import 'package:bluebus/shared/mcolors.dart';
import 'package:bluebus/shared/mtext.dart';
import 'package:bluebus/shared/sbox.dart';
import 'package:bluebus/ui/auth/login_screen.dart';
import 'package:bluebus/ui/auth/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MColors.background,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SBox(height: 20, width: 0),
              Column(
                children: [
                  Image.asset(
                    "assets/images/welcome.png",
                    height: 230,
                  ),
                  Text(
                    "PurpleBus",
                    style: GoogleFonts.playfairDisplay(
                      textStyle: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: MColors.primary,
                      ),
                    ),
                  ),
                  Text(
                    "Đồng hành cùng bạn",
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: MColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: MColors.background,
                      backgroundColor: MColors.primary,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const MText(
                        content: "Đăng nhập",
                        size: 20,
                        bold: false,
                        italic: false),
                  ),
                  const SBox(height: 15, width: 0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: MColors.primary,
                      backgroundColor: MColors.primaryContainer,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const MText(
                        content: "Đăng ký",
                        size: 20,
                        bold: false,
                        italic: false),
                  ),
                ],
              ),
              const SBox(height: 1, width: 0),
              const SBox(height: 1, width: 0),
            ],
          ),
        ),
      ),
    );
  }
}
