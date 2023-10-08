import 'package:bluebus/models/user.dart';
import 'package:bluebus/shared/mcolors.dart';
import 'package:bluebus/ui/main/home.dart';
import 'package:bluebus/ui/main/notification.dart';
import 'package:bluebus/ui/main/account/account.dart';
import 'package:bluebus/ui/main/tickets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigatorRoute extends StatefulWidget {
  NavigatorRoute({int? pageIndex, super.key}) {
    if (pageIndex != null) {
      internalIndex = pageIndex;
    } else {
      internalIndex = 0;
    }
  }

  late final int internalIndex;

  @override
  State<NavigatorRoute> createState() => _NavigatorRouteState();
}

class _NavigatorRouteState extends State<NavigatorRoute> {
  late int pageIndex;
  static List<Widget> page = [
    const HomePage(),
    const TicketsScreen(),
    const NotificationScreen(),
    AccountSceen(key: UniqueKey()),
  ];

  var user = Users(
    fullName: "",
    address: "",
    email: "",
    phoneNumber: "",
    profilePhoto:
        "https://firebasestorage.googleapis.com/v0/b/purplebus-ee57f.appspot.com/o/default_avatar.png?alt=media&token=14653759-47ca-4964-995d-63c0f628e84d&_gl=1*1xdiu81*_ga*NjgzODM5Njg5LjE2ODQ4OTgwNTA.*_ga_CW55HF8NVT*MTY5NjE3NzMzNS4yOS4xLjE2OTYxNzczNDcuNDguMC4w",
  );

  @override
  void initState() {
    super.initState();
    loadUserData();
    pageIndex = widget.internalIndex;
  }

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
    }
  }

  void _changePageIndex(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _changePageIndex,
        elevation: 0,
        currentIndex: pageIndex,
        unselectedItemColor: MColors.secondary,
        showUnselectedLabels: false,
        selectedItemColor: MColors.primary,
        backgroundColor: MColors.background,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(
              Icons.home,
            ),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity_outlined),
            activeIcon: Icon(Icons.local_activity),
            label: "Vé xe",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(
              Icons.notifications_active,
            ),
            label: "Thông báo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(
              Icons.person,
            ),
            label: "Tài khoản",
          ),
        ],
      ),
    );
  }
}
