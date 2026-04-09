import 'package:get/get.dart';

import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/profile/edit_profile_view.dart';
import '../modules/profile/change_password_view.dart';
import '../modules/profile/contact_us_view.dart';
import '../modules/profile/terms_privacy_view.dart';
import '../modules/profile/faq_view.dart';

class ProfileRoutes {
  ProfileRoutes._();

  static const profile = '/profile';
  static const profileEdit = '/profile-edit';
  static const changePassword = '/change-password';
  static const contactUs = '/contact-us';
  static const termsPrivacy = '/terms-privacy';
  static const faq = '/faq';

  static final routes = [
    GetPage(
      name: profile,
      page: ProfileView.new,
      binding: ProfileBinding(),
    ),
    GetPage(
      name: profileEdit,
      page: () => const EditProfileView(),
    ),
    GetPage(
      name: changePassword,
      page: () => const ChangePasswordView(),
    ),
    GetPage(
      name: contactUs,
      page: () => const ContactUsView(),
    ),
    GetPage(
      name: termsPrivacy,
      page: () => const TermsPrivacyView(),
    ),
    GetPage(
      name: faq,
      page: () => const FAQView(),
    ),
  ];
}
