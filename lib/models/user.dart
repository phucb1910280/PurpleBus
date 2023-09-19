class Users {
  String? fullName;
  String? address;
  String? email;
  String? phoneNumber;
  DateTime? registerDay;

  Users({
    required this.fullName,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.registerDay,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'registerDay': registerDay,
    };
  }

  Map<String, Object?> toJson() {
    return {
      'fullName': fullName,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'registerDay': registerDay,
    };
  }
}
