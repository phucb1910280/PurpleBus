import 'package:bluebus/models/user.dart';
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
  var user = Users(
      fullName: "",
      address: "",
      email: "",
      phoneNumber: "",
      profilePhoto:
          "https://firebasestorage.googleapis.com/v0/b/purplebus-ee57f.appspot.com/o/default_avatar.png?alt=media&token=14653759-47ca-4964-995d-63c0f628e84d&_gl=1*1xdiu81*_ga*NjgzODM5Njg5LjE2ODQ4OTgwNTA.*_ga_CW55HF8NVT*MTY5NjE3NzMzNS4yOS4xLjE2OTYxNzczNDcuNDguMC4w");

  loadUserData() async {
    var data = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    if (data.exists) {
      var tempUser = Users(
          fullName: data["fullName"],
          address: data["address"],
          email: data["email"],
          phoneNumber: data["phoneNumber"],
          isNewUser: data["isNewUser"],
          point: data["point"],
          profilePhoto: data["profilePhoto"]);
      setState(() {
        user = tempUser;
      });
      // debugPrint(user.toJson().toString());
    }
  }

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
  void initState() {
    loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin tài khoản"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            userAvt(),
            const SBox(height: 25, width: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const MText(
                    content: "Họ tên:", size: 18, bold: false, italic: false),
                Flexible(
                  child: Text(
                    user.fullName.toString(),
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
                  user.phoneNumber.toString(),
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
                    content: "Email:", size: 18, bold: false, italic: false),
                const SBox(height: 0, width: 20),
                Flexible(
                  child: Text(
                    user.email.toString(),
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
                    content: "Địa chỉ:", size: 18, bold: false, italic: false),
                const SBox(height: 0, width: 20),
                Flexible(
                  child: Text(
                    user.address.toString(),
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
                  MaterialPageRoute(builder: (context) => const EditProfile()),
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
                  content: "Đăng xuất", size: 18, bold: false, italic: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget userAvt() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(user.profilePhoto.toString()),
        ),
      ),
    );
  }
}
