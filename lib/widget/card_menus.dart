import 'package:flutter/material.dart';

SizedBox buildCardMenus(List restaurant, Axis scroll) {
  return SizedBox(
    height: 70,
    child: ListView.builder(
      scrollDirection: scroll,
      itemCount: restaurant.length,
      itemBuilder: (context, index) {
        var item = restaurant[index];
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                color: Color(0xFF1A4D2E),
              )),
          color: const Color(0xFFF5EFE6),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                item.name,
                style: const TextStyle(color: Color(0xFF1A4D2E)),
              ),
            ),
          ),
        );
      },
    ),
  );
}
