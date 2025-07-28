import 'package:get/get.dart';
import '../modules/feedback/feedback_binding.dart';
import '../modules/feedback/feedback_view.dart';

class FeedbackRoutes {
  FeedbackRoutes._();

  static const FEEDBACK = '/feedback';

  static final routes = [
    GetPage(
      name: FEEDBACK,
      page: () => const FeedbackView(),
      binding: FeedbackBinding(),
    ),
  ];
}