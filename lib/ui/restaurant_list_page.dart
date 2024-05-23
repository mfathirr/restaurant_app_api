import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/provider/restaurant_provider.dart';

import '../widget/card_list_widget.dart';

class RestaurantList extends StatelessWidget {
  final String getImage = "https://restaurant-api.dicoding.dev/images/medium/";
  const RestaurantList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: _buildAppBar(context),
      ),
      body: Column(
        children: [
          _buildSeachBar(context),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Column _buildAppBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Restaurant',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: const Color(0xFF1A4D2E)),
        ),
        Text(
          'Recommendation for you',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF1A4D2E),
              ),
        )
      ],
    );
  }

  Padding _buildSeachBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: TextField(
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1A4D2E), width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            hintText: 'Search',
          ),
          onChanged: (value) =>
              Provider.of<RestaurantProvider>(context, listen: false)
                  .fetchAllRestaurant(value)),
    );
  }

  Consumer<RestaurantProvider> _buildList() {
    return Consumer<RestaurantProvider>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.state == ResultState.hasData) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.resultSearch.length,
          itemBuilder: (context, index) {
            var restaurant = state.resultSearch[index];
            return cardRestaurant(restaurant, context, getImage);
          },
        );
      } else {
        return Center(
          child: Material(
            child: Text(state.message),
          ),
        );
      }
    });
  }
}
