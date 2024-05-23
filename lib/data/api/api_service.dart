import 'dart:async';

import 'package:restaurant_app_api/data/model/restaurant_detail.dart';
import 'package:restaurant_app_api/data/model/restaurant_search.dart';

import '../model/restaurant.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

class ApiService {
  static const String _listData = 'list';

  Future<Welcome> fetchData() async {
    const String url = "$_baseUrl$_listData";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Welcome.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class ApiDetail {
  static const String _detailData = 'detail/';

  Future<WelcomeDetail> fetchDetailData(String id) async {
    String url = "$_baseUrl$_detailData$id";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return WelcomeDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class ApiSearch {
  static const String _searchData = 'search?q=';
  Future<RestaurantSearch> fetchSearchData(String query) async {
    String url = "$_baseUrl$_searchData$query";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
