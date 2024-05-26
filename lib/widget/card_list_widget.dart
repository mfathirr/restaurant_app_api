import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/model/restaurant.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';

import '../common/navigation.dart';

Material cardRestaurant(
    RestaurantElement restaurant, BuildContext context, image) {
  return Material(
    child: GestureDetector(
      onTap: () {
        Navigation.intenWithData(DetailPage.routeName, restaurant.id);
      },
      child: Card(
          margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          color: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xFF1A4D2E),
              ),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(children: [
            _buildRoundedImage(image, restaurant, context),
            _buildTextCard(restaurant, context),
          ])),
    ),
  );
}

Padding _buildTextCard(RestaurantElement restaurant, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(13),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600, color: const Color(0xFF1A4D2E)),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  restaurant.city,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: const Color(0xFF1A4D2E)),
                ),
              ],
            ),
            const SizedBox(
              width: 5.0,
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Text(
                  restaurant.rating.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: const Color(0xFF1A4D2E)),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

ClipRRect _buildRoundedImage(
    image, RestaurantElement restaurant, BuildContext context) {
  return ClipRRect(
    borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12), topRight: Radius.circular(12)),
    child: Hero(
      tag: restaurant.pictureId,
      child: Image.network(
        "$image${restaurant.pictureId}",
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4,
      ),
    ),
  );
}
