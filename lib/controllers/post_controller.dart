import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_4z/model/post.dart';

class PostController extends GetxController {
  var isLoading = false.obs;
  RxString isConnected = 'offline'.obs;
  Timer? timer;

  List<Child>? posts;
  List<Child>? offlinePosts;
  @override
  Future onInit() async {
    super.onInit();
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => checkConnection());
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      isConnected.value = 'online';
    } else {
      isConnected.value = 'offline';
    }
    isConnected.refresh;
  }

  fetchData() async {
    try {
      isLoading(true);
      http.Response response =
          await http.get(Uri.tryParse('https://www.reddit.com/r/dart/.json')!);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        posts = PostModel.fromJson(result).data.children;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Map<String, dynamic> postsModel = ;

      // bool result = await prefs.setString('user', jsonEncode(user));
    } catch (e) {
      //print(e);
    } finally {
      isLoading(false);
    }
  }

  fetchDataOffline() async {
    try {
      SharedPreferences shared_User = await SharedPreferences.getInstance();
      if (shared_User.getString('posts')!.isEmpty) {
        print('empty');
      } else {
        print('done');
        Map<String, dynamic> postsData =
            jsonDecode(shared_User.getString('posts')!);
        offlinePosts = PostModel.fromJson(postsData).data.children;
        print(offlinePosts);
      }
    } catch (e) {
      //print(e);
    } finally {
      isLoading(false);
    }
  }
}
