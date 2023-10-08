class Users {
  String? fullName;
  String? address;
  String email;
  String? phoneNumber;
  bool? isNewUser = true;
  num? point = 0;
  DateTime? registerDay;
  String? profilePhoto;

  Users({
    this.fullName,
    this.address,
    required this.email,
    this.phoneNumber,
    this.registerDay,
    this.isNewUser,
    this.point,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'isNewUser': true,
      'point': 0,
      'profilePhoto':
          "https://firebasestorage.googleapis.com/v0/b/purplebus-ee57f.appspot.com/o/default_avatar.png?alt=media&token=14653759-47ca-4964-995d-63c0f628e84d",
      'registerDay': registerDay,
    };
  }

  Map<String, Object?> toJson() {
    return {
      'fullName': fullName,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'isNewUser': true,
      'point': 0,
      'profilePhoto':
          "https://firebasestorage.googleapis.com/v0/b/purplebus-ee57f.appspot.com/o/default_avatar.png?alt=media&token=14653759-47ca-4964-995d-63c0f628e84d",
      'registerDay': registerDay,
    };
  }
}
