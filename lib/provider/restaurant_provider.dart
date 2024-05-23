import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  String query = '';

  RestaurantProvider(this.apiService) {
    fetchAllRestaurant(query);
  }

  late ResultState _state;
  String _message = '';

  String get message => _message;
  ResultState get state => _state;
  List<RestaurantElement> resultSearch = [];

  Future<dynamic> fetchAllRestaurant(String enteredKey) async {
    try {
      _state = ResultState.loading;
      final restaurant = await apiService.fetchData();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = 'Data is Empty';
      } else {
        _state = ResultState.hasData;
        if (enteredKey.isEmpty) {
          resultSearch = restaurant.restaurants;
        } else {
          resultSearch = restaurant.restaurants
              .where((res) =>
                  res.name.toLowerCase().contains(enteredKey.toLowerCase()))
              .toList();
        }
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load data';
    }
    notifyListeners();
  }
}
