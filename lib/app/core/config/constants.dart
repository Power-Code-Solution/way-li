import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// const kPrimaryColor = Color.fromARGB(255, 90, 176, 87);
const kPrimaryColor = Color.fromARGB(255, 72, 95, 30);
const primaryColor = Color(0xFFFDED01);
const secondaryColor = Color(0xFF272300);
// const kPrimaryColor = Color(0xFFA0CC51);
const kLitePrimaryColor = Color(0xFF04DBB5);
const kRedColor = Colors.red;
const kHeaderColor = Color(0xFFF9E400);
// const kHeaderColor = Color.fromRGBO(124, 0, 254, 1);
// const kHeaderColor = Color.fromRGBO(124, 0, 254, 1);
const kYellowColor = Color(0xFFF9E400);
const kLimeAcentColor = Colors.limeAccent;
const kSecondaryColor = Colors.grey;
const kIconColor = Color.fromARGB(255, 6, 99, 238);
const kWhiteColor = Color.fromARGB(255, 255, 255, 255);
const kPrimaryLightColor = Color.fromARGB(255, 20, 46, 47);
const kOrangeColor = Color(0xFFFF7643);
const double largeTextSize = 18;

var kPrimaryGradientColor = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.white,
    Colors.white
    // Color(0xFFFFA53E).withOpacity(0.2),
    // Color(0xFFFF7643).withOpacity(0.2)
  ],
);

const kTextColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);
const apiBaseAddress = "http://5.196.8.55:8080/";
//const apiBaseAddress = "https://b181-2a01-cb08-b6-8a00-d420-9fa-696b-e8d9.ngrok-free.app/";

const whatSappLink =
    "https://wa.me/23279366751?text=Hello,%20I%20want%20to%20know%20more%20about%20your%20service,%20can%20you%20tell%20me%20more?%20my%20name%20is%20.....";
// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";


final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}



const kSpacingUnit = 10;

const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);

final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.7),
  fontWeight: FontWeight.w600,
);

final kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
  fontWeight: FontWeight.w100,
);

final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  fontWeight: FontWeight.w400,
  color: kDarkPrimaryColor,
);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: kLightSecondaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kLightSecondaryColor,
        displayColor: kLightSecondaryColor,
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kAccentColor).copyWith(background: kDarkSecondaryColor),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: kDarkSecondaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kDarkSecondaryColor,
        displayColor: kDarkSecondaryColor,
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kAccentColor).copyWith(background: kLightSecondaryColor),
);