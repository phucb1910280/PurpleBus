import 'package:bluebus/shared/mcolors.dart';
import 'package:bluebus/shared/mtext.dart';
import 'package:bluebus/shared/sbox.dart';
import 'package:bluebus/ui/auth/welcome_screen.dart';
import 'package:bluebus/ui/main/account/profile_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Thông báo'),
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SBox(height: 20, width: 0),
                  Image.asset(
                    "assets/icons/caution.png",
                    color: MColors.primary,
                    height: 100,
                  ),
                  const SBox(height: 30, width: 0),
                  const Center(
                    child: Text(
                      "Bạn muốn đăng xuất?",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MColors.primaryContainer,
                      foregroundColor: MColors.primary,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Hủy",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SBox(height: 0, width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: signOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MColors.primary,
                      foregroundColor: MColors.background,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Đồng ý",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    if (FirebaseAuth.instance.currentUser == null) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Thông tin tài khoản"),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      userAvt(snapshot.data["profilePhoto"]),
                      const SBox(height: 15, width: 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FirebaseAuth.instance.currentUser!.emailVerified
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red,
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          MText(
                              content: FirebaseAuth
                                      .instance.currentUser!.emailVerified
                                  ? "Đã xác thực"
                                  : "Chưa xác thực",
                              size: 15,
                              bold: false,
                              italic: true),
                        ],
                      ),
                      const SBox(height: 35, width: 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const MText(
                              content: "Họ tên:",
                              size: 18,
                              bold: false,
                              italic: false),
                          Flexible(
                            child: Text(
                              snapshot.data["fullName"],
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 18,
                                color: MColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SBox(height: 15, width: 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const MText(
                              content: "Số điện thoại:",
                              size: 18,
                              bold: false,
                              italic: false),
                          Text(
                            snapshot.data["phoneNumber"],
                            style: const TextStyle(
                              fontSize: 18,
                              color: MColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SBox(height: 15, width: 0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const MText(
                              content: "Email:",
                              size: 18,
                              bold: false,
                              italic: false),
                          const SBox(height: 0, width: 20),
                          Flexible(
                            child: Text(
                              snapshot.data["email"],
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 18,
                                color: MColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SBox(height: 15, width: 0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const MText(
                              content: "Địa chỉ:",
                              size: 18,
                              bold: false,
                              italic: false),
                          const SBox(height: 0, width: 20),
                          Flexible(
                            child: Text(
                              snapshot.data["address"],
                              maxLines: 5,
                              style: const TextStyle(
                                fontSize: 18,
                                color: MColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditProfile()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MColors.primary,
                          foregroundColor: MColors.background,
                          minimumSize: const Size.fromHeight(55),
                        ),
                        child: const MText(
                            content: "Chỉnh sửa thông tin",
                            size: 18,
                            bold: false,
                            italic: false),
                      ),
                      const SBox(height: 10, width: 0),
                      ElevatedButton(
                        onPressed: showAlertDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MColors.primaryContainer,
                          foregroundColor: MColors.primary,
                          minimumSize: const Size.fromHeight(55),
                        ),
                        child: const MText(
                            content: "Đăng xuất",
                            size: 18,
                            bold: false,
                            italic: false),
                      ),
                    ],
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }

  Widget userAvt(String imgUrl) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imgUrl),
        ),
      ),
    );
  }
}
