import 'package:get/get.dart';

import 'tags_controller.dart';

class TagsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TagsController>(
      TagsController.new,
    );
  }
}
