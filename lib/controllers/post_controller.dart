import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:task_4z/model/post.dart';

class PostController extends GetxController {
  var isLoading = false.obs;
  RxBool isConnected = false.obs;

  List<Child>? posts;
  @override
  Future onInit() async {
    super.onInit();
    checkConnection();
    fetchData();
  }

  Future<bool> checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      isConnected = true.obs;
    } else {
      isConnected = false.obs;
    }
    return isConnected.value;
  }

  fetchData() async {
    try {
      isLoading(true);
      http.Response response =
          await http.get(Uri.tryParse('https://www.reddit.com/r/dart/.json')!);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        posts = PostModel.fromJson(result).data.children;
      } else {
        //error
      }
    } catch (e) {
      //print(e);
    } finally {
      isLoading(false);
    }
  }
}
