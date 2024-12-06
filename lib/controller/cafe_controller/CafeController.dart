import 'dart:convert';
import 'dart:developer';
import 'package:heavens_students/model/categoryList_model.dart';
import 'package:heavens_students/model/category_model.dart';
import 'package:heavens_students/model/search_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/base_url.dart';
import 'package:heavens_students/model/cafe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CafeController with ChangeNotifier {
  List<SearchModel>? searchModel;
  bool _isloading = false;
  bool get isLoading => _isloading;
  set isLoading(bool value) {
    _isloading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  int _currentPage = 1;
  final int _itemsPerPage = 10;
  List<CafeAllItemModel> AllItemModel = [];
  List<CategoryNameListModel>? categoryNameListModel;
  CategoryModel? categoryModel;

  // Future<void> getCafeItems() async {
  //   if (isLoading) return;
  //   isLoading = true;

  //   final url =
  //       '${UrlConst.baseUrl}/CafeItem/get?page=$_currentPage&limit=$_itemsPerPage';

  //   log("url----$url");

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final accessToken = prefs.getString("access_token") ?? "";
  //   final headers = {
  //     'Authorization': 'Bearer $accessToken',
  //     'Content-Type': 'application/json',
  //   };

  //   final response = await http.get(Uri.parse(url), headers: headers);
  //   log("status code get all list --${response.statusCode}");

  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     log("Fetched successfully---");

  //     // Access the foodItems list from the response
  //     List<dynamic> foodItems = data['cafeItems'];

  //     AllItemModel.addAll(
  //         foodItems.map((item) => CafeAllItemModel.fromJson(item)).toList());
  //     log("length of ---${AllItemModel.length}");
  //     if (foodItems.length == _itemsPerPage) {
  //       _currentPage++;
  //     }
  //   } else {
  //     log('Failed to load cafe all items : ${response.statusCode}');
  //   }

  //   notifyListeners();
  //   isLoading = false;
  // }
  Future<void> getCafeItems() async {
    if (isLoading) return;
    isLoading = true;

    final url =
        '${UrlConst.baseUrl}/CafeItem/get?page=$_currentPage&limit=$_itemsPerPage';

    log("url----$url");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    // Check if cached data exists
    String? cachedData = prefs.getString('cafeItems_page_$_currentPage');

    if (cachedData != null) {
      var data = json.decode(cachedData);
      log("Loaded from cache---");

      List<dynamic> foodItems = data['cafeItems'];
      AllItemModel.addAll(
          foodItems.map((item) => CafeAllItemModel.fromJson(item)).toList());

      log("length of ---${AllItemModel.length}");
      if (foodItems.length == _itemsPerPage) {
        _currentPage++;
      }

      notifyListeners();
      isLoading = false;
      return;
    }

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      log("status code get all list --${response.statusCode}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log("Fetched successfully---");

        // Access the foodItems list from the response
        List<dynamic> foodItems = data['cafeItems'];

        AllItemModel.addAll(
            foodItems.map((item) => CafeAllItemModel.fromJson(item)).toList());

        log("length of ---${AllItemModel.length}");

        // Save the fetched data to cache
        await prefs.setString('cafeItems_page_$_currentPage', response.body);

        if (foodItems.length == _itemsPerPage) {
          _currentPage++;
        }

        notifyListeners();
      } else {
        log('Failed to load cafe all items : ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching cafe items: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> getCategoryName() async {
    isLoading = true;

    final url = '${UrlConst.baseUrlCafe}/Category';
    log("url----$url");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    log("status code--${response.statusCode}");

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      // log("data---$data");
      log("Category Fetched successfully");

      categoryNameListModel =
          data.map((item) => CategoryNameListModel.fromJson(item)).toList();
    } else {
      log('Failed to load categories: ${response.statusCode}');
    }
    isLoading = false;
    notifyListeners();
  }

  bool _isCategorySelected = false;
  bool get isCategorySelected => _isCategorySelected;

  set isCategorySelected(bool value) {
    _isCategorySelected = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  List<dynamic> get items =>
      isCategorySelected ? categoryModel?.foodItems ?? [] : AllItemModel;

  resetCategory() {
    isCategorySelected = false;
    notifyListeners();
  }

  Future<void> getCategoryItems(String id) async {
    isLoading = true;

    final url = '${UrlConst.baseUrlCafe}/Category/$id';
    log("url----$url");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    log("status code--${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log("Category list fetched successfully");
      categoryModel = CategoryModel.fromJson(data);

      isCategorySelected = true;
    } else {
      log('Failed to load categories: ${response.statusCode}');
    }
    isLoading = false;
    notifyListeners();
  }

// change name

  String selectedCategoryName = "Heavens Cafe";
  int itemNo = 0;
  void setSelectedCategory(String name, int length) {
    selectedCategoryName = name;
    itemNo = length;
    log("Selecetd category name----$selectedCategoryName");
    log("Selecetd category lenth----$itemNo");
    notifyListeners();
  }

  // search function
  int searchResponse = 0;
  searchCafeItems(String searchText) async {
    isLoading = true;
    final url = '${UrlConst.baseUrlCafe}/CafeItem/cafe/search?name=$searchText';
    log("url----$url");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    log("status code--${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log("search is fetched successfully");
      searchModel = data
          .map<SearchModel>(
              (json) => SearchModel.fromJson(json as Map<String, dynamic>))
          .toList();
      searchResponse = 0;
    } else {
      log('Failed to load search: ${response.statusCode}');
      searchResponse = response.statusCode;
    }
    isLoading = false;
    notifyListeners();
  }
}
