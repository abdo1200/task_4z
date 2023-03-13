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
          FutureBuilder<bool>(
              future: controller.checkConnection(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return Obx(
                      () => controller.isLoading.value
                          ? SizedBox(
                              height: Get.height * .7,
                              child: Center(
                                child: LoadingAnimationWidget.discreteCircle(
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  itemCount: controller.posts!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Get.to(() => PostDetails(
                                          post: controller.posts![index].data)),
                                      child: PostCard(
                                          author: controller
                                              .posts![index].data.author,
                                          title: controller
                                              .posts![index].data.title),
                                    );
                                  },
                                ),
                              ),
                            ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2,
                                    spreadRadius: .5)
                              ]),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Please check your internet connection',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await controller.checkConnection();
                            if (controller.isConnected.value) {
                              await controller.fetchData();
                              Get.to(() => Home());
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 2,
                                        spreadRadius: .5)
                                  ]),
                              child: const Text('Try Again',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber))),
                        )
                      ],
                    );
                  }
                } else {
                  return SizedBox(
                    height: Get.height * .7,
                    child: Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  );
                }
              })
        ],
      )),
    );
  }
}
