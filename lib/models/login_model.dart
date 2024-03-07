// Login server response
class LoginModel {
  String id;
  String firstName;
  String lastName;
  String jwtToken;
    String photo;
  String emailAddress;
  String mobileNumber;
  int distanceUnit;

  LoginModel(
      this.id,
      this.firstName,
      this.lastName,
      this.jwtToken,
      this.photo,
      this.emailAddress,
      this.mobileNumber,
      this.distanceUnit
      );

  LoginModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        jwtToken = json['jwtToken'],
        photo = json['photo'],
        emailAddress = json['emailAddress'],
        mobileNumber = json['mobileNumber'],
        distanceUnit = json['distanceUnit'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'jwtToken' : jwtToken,
        'photo' : photo,
        'emailAddress' : emailAddress,
        'mobileNumber': mobileNumber,
        'distanceUnit': distanceUnit
      };
}