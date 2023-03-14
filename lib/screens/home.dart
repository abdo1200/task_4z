import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task_4z/controllers/post_controller.dart';
import 'package:get/get.dart';
import 'package:task_4z/screens/post_details.dart';
import 'package:task_4z/widgets/post_cart.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final PostController controller = Get.put(PostController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(height: 20),
          SvgPicture.asset(
            'assets/reddit-logo.svg',
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() =>
                  Text('Active statu : ${controller.isConnected.value}   ')),
              Obx(() => controller.isConnected.value == 'online'
                  ? Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)),
                    )
                  : Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50)),
                    )),
            ],
          ),
          Obx(() => controller.isChecking.value
              ? SizedBox(
                  height: Get.height * .8,
                  child: Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                )
              : controller.isConnected.value == "online"
                  ? controller.isLoading.value
                      ? SizedBox(
                          height: Get.height * .8,
                          child: Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: Get.height * .8,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: controller.posts!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => Get.to(() => PostDetails(
                                      post: controller.posts![index].data)),
                                  child: PostCard(
                                      author:
                                          controller.posts![index].data.author,
                                      title:
                                          controller.posts![index].data.title),
                                );
                              },
                            ),
                          ),
                        )
                  : controller.offlinePosts.isNull
                      ? Container(
                          margin: const EdgeInsets.only(top: 40),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text('Check your internet connection'))
                      : SizedBox(
                          height: Get.height * .8,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: controller.offlinePosts!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => Get.to(() => PostDetails(
                                      post: controller
                                          .offlinePosts![index].data)),
                                  child: PostCard(
                                      author: controller
                                          .offlinePosts![index].data.author,
                                      title: controller
                                          .offlinePosts![index].data.title),
                                );
                              },
                            ),
                          ),
                        ))
        ],
      )),
    );
  }
}
