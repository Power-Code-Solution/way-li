class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String address;
  final int fkCityId;
  final int fkCommunityId;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.fkCityId,
    required this.fkCommunityId,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "phone": phone,
      "address": address,
      "fkCityId": fkCityId,
      "fkCommunityId": fkCommunityId,
    };
  }
}
