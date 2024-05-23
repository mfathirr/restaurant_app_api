import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiDetail apiDetail;
  String id;

  RestaurantDetailProvider({required this.apiDetail, required this.id}) {
    _fetchDetailRestaurant();
  }

  late WelcomeDetail _detail;
  late ResultState _state;
  String _message = '';

  WelcomeDetail get result => _detail;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> _fetchDetailRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantDetail = await apiDetail.fetchDetailData(id);
      if (restaurantDetail.restaurant.id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data is Empty';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detail = restaurantDetail;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Failed to load data';
    }
  }
}
