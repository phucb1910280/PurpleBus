import 'dart:io';

import 'package:bluebus/models/user.dart';
import 'package:bluebus/shared/mcolors.dart';
import 'package:bluebus/shared/mtext.dart';
import 'package:bluebus/shared/navigator.dart';
import 'package:bluebus/shared/sbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var fullNameCtrl = TextEditingController();
  var phoneNumberCtrl = TextEditingController();
  var addressCtrl = TextEditingController();
  String filePath = "";
  String userAvtStr =
      "https://firebasestorage.googleapis.com/v0/b/purplebus-ee57f.appspot.com/o/default_avatar.png?alt=media&token=14653759-47ca-4964-995d-63c0f628e84d&_gl=1*1xdiu81*_ga*NjgzODM5Njg5LjE2ODQ4OTgwNTA.*_ga_CW55HF8NVT*MTY5NjE3NzMzNS4yOS4xLjE2OTYxNzczNDcuNDguMC4w";

  String errorAvt =
      "https://firebasestorage.googleapis.com/v0/b/purplebus-ee57f.appspot.com/o/default_avatar.png?alt=media&token=14653759-47ca-4964-995d-63c0f628e84d&_gl=1*1xdiu81*_ga*NjgzODM5Njg5LjE2ODQ4OTgwNTA.*_ga_CW55HF8NVT*MTY5NjE3NzMzNS4yOS4xLjE2OTYxNzczNDcuNDguMC4w";
  final _formKey = GlobalKey<FormState>();

  var user = Users(
    fullName: "",
    address: "",
    email: "",
    phoneNumber: "",
  );

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
        fullNameCtrl.text = user.fullName.toString();
        phoneNumberCtrl.text = user.phoneNumber.toString();
        addressCtrl.text = user.address.toString();
        userAvtStr = user.profilePhoto.toString();
      });
    }
  }

  Future<void> updateUserData() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.email)
          .update({
        "fullName": fullNameCtrl.text,
        "phoneNumber": phoneNumberCtrl.text,
        "address": addressCtrl.text,
      }).then((value) => showAlertDialog());
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  Future updateUserAvt() async {
    uploadFile().then(
      (value) async => {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .update(
          {
            "profilePhoto": userAvtStr,
          },
        ),
      },
    );
  }

  UploadTask? uploadTask;
  PlatformFile? pickedFile;

  Future selecFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    setState(() {
      pickedFile = result.files.first;
      filePath = pickedFile!.path.toString();
    });
  }

  Future uploadFile() async {
    final path = "avt/${FirebaseAuth.instance.currentUser!.email}";
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() => null);
    userAvtStr = await snapshot.ref.getDownloadURL();
    debugPrint(userAvtStr);
  }

  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SBox(height: 20, width: 0),
                Image.asset(
                  "assets/icons/success_icon.png",
                  height: 100,
                ),
                const SBox(height: 30, width: 0),
                const MText(
                  content: "Cập nhật hoàn tất",
                  size: 20,
                  bold: false,
                  italic: false,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigatorRoute(
                      pageIndex: 3,
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  @override
  void dispose() {
    fullNameCtrl.dispose();
    phoneNumberCtrl.dispose();
    addressCtrl.dispose();
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
          title: const Text("Chỉnh sửa thông tin"),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const SBox(height: 20, width: 0),
                      userAvt(filePath),
                      const SBox(height: 40, width: 0),
                      editFormField(),
                      const Expanded(
                        child: SizedBox(
                          height: 15,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MColors.primaryContainer,
                                foregroundColor: MColors.primary,
                                minimumSize: const Size.fromHeight(55),
                              ),
                              child: const MText(
                                content: "Hủy",
                                size: 18,
                                bold: false,
                                italic: false,
                              ),
                            ),
                          ),
                          const SBox(height: 0, width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (pickedFile != null) {
                                    updateUserAvt();
                                  }
                                  updateUserData();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MColors.primary,
                                foregroundColor: MColors.background,
                                minimumSize: const Size.fromHeight(55),
                              ),
                              child: const MText(
                                content: "Cập nhật",
                                size: 18,
                                bold: false,
                                italic: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SBox(height: 15, width: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget editFormField() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: fullNameCtrl,
            obscureText: false,
            maxLength: 50,
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
              counterText: "",
              hintText: "Họ tên",
              hintStyle: const TextStyle(
                fontSize: 17,
              ),
              prefixIcon: const Icon(
                Icons.person,
                color: MColors.primary,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    fullNameCtrl.text = "";
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
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng nhập họ tên";
              }
              return null;
            },
          ),
          const SBox(height: 15, width: 0),
          TextFormField(
            controller: phoneNumberCtrl,
            obscureText: false,
            maxLength: 10,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
              counterText: "",
              hintText: "Số điện thoại",
              hintStyle: const TextStyle(
                fontSize: 17,
              ),
              prefixIcon: const Icon(
                Icons.phone,
                color: MColors.primary,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    phoneNumberCtrl.text = "";
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
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng nhập số điện thoại";
              }
              if (!value.startsWith("0") || value.length < 10) {
                return "Số điện thoại không hợp lệ";
              }
              return null;
            },
          ),
          const SBox(height: 15, width: 0),
          TextFormField(
            controller: addressCtrl,
            obscureText: false,
            maxLength: 150,
            style: const TextStyle(
              fontSize: 18,
            ),
            maxLines: null,
            decoration: InputDecoration(
              counterText: "",
              hintText: "Địa chỉ",
              hintStyle: const TextStyle(
                fontSize: 17,
              ),
              prefixIcon: const Icon(
                Icons.maps_home_work_sharp,
                color: MColors.primary,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    addressCtrl.text = "";
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
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng nhập địa chỉ";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget userAvt(String? imgFilePath) {
    return Stack(
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            backgroundImage: filePath.isEmpty
                ? NetworkImage(userAvtStr)
                : Image.file(
                    File(imgFilePath.toString()),
                    fit: BoxFit.cover,
                  ).image,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: MColors.primary.withOpacity(.8),
              shape: BoxShape.circle,
            ),
            height: 40,
            width: 40,
            child: IconButton(
              onPressed: () async {
                selecFile();
              },
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: MColors.background,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
