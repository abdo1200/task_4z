import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_4z/model/post.dart';

class PostController extends GetxController {
  var isLoading = false.obs;
  var isChecking = false.obs;
  RxString isConnected = 'offline'.obs;
  Timer? timer;

  List<Child>? posts;
  List<Child>? offlinePosts;
  @override
  Future onInit() async {
    super.onInit();
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => checkConnection());
    fetchDataOffline();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  checkConnection() async {
    try {
      isChecking(true);
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        if (isConnected.value == 'online') {
          await fetchDataOffline();
        }
        isConnected.value = 'offline';
      } else {
        if (isConnected.value == 'offline') {
          await fetchData();
        }
        isConnected.value = 'online';
      }
      isConnected.refresh;
    } catch (e) {
    } finally {
      isChecking(false);
    }
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

      savedLocal(response.body);
    } catch (e) {
      //print(e);
    } finally {
      isLoading(false);
    }
  }

  savedLocal(var result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> postsModel = jsonDecode(result);
    //print(postsModel);
    await prefs.setString('posts', jsonEncode(postsModel)).then((value) {
      if (value) print('saved in local storage');
    });
  }

  fetchDataOffline() async {
    try {
      SharedPreferences sharedUser = await SharedPreferences.getInstance();
      if (sharedUser.getString('posts')!.isEmpty) {
      } else {
        Map<String, dynamic> postsData =
            jsonDecode(sharedUser.getString('posts')!);
        offlinePosts = PostModel.fromJson(postsData).data.children;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
