import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/model/restaurant.dart';

import '../data/database/database_helper.dart';

enum ResultState { loading, noData, hasData, error }

class DbProvider extends ChangeNotifier {
  late DatabaseHelper _dbHelper;

  List<RestaurantElement> _favorite = [];
  String _message = '';
  late ResultState _state;

  List<RestaurantElement> get favorite => _favorite;
  String get message => _message;
  ResultState get state => _state;

  DbProvider() {
    _dbHelper = DatabaseHelper();
    _getAllFavorites();
  }

  void _getAllFavorites() async {
    _favorite = await _dbHelper.getFavorites();
    if (_favorite.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'No Data';
    }
    notifyListeners();
  }

  Future<void> addFavorite(RestaurantElement restaurant) async {
    try {
      await _dbHelper.insertFavorite(restaurant);
      _getAllFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await _dbHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }

  void deleteFavorite(String id) async {
    try {
      _dbHelper.deleteFavorite(id);
      _getAllFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error';
      notifyListeners();
    }
  }
}
