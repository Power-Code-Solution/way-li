import 'package:get/get.dart';
import '../modules/about/about_binding.dart';
import '../modules/about/about_view.dart';
import '../modules/help/help_binding.dart';
import '../modules/help/help_view.dart';
import '../modules/transactions/transactions_binding.dart';
import '../modules/transactions/transactions_view.dart';

class InfoRoutes {
  InfoRoutes._();

  static const about = '/about';
  static const help = '/help';
  static const transactions = '/transactions';

  static final routes = [
    GetPage(
      name: about,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: help,
      page: () => const HelpView(),
      binding: HelpBinding(),
    ),
    GetPage(
      name: transactions,
      page: () => const TransactionsView(),
      binding: TransactionsBinding(),
    ),
  ];
}
