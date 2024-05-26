import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/provider/db_provider.dart';

import 'restaurant_detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Restaurant',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<DbProvider>(
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: state.favorite.length,
            itemBuilder: (context, index) {
              var favorite = state.favorite[index];
              return Dismissible(
                key: Key(state.favorite[index].id.toString()),
                background: Container(
                  color: Colors.red,
                ),
                onDismissed: (direction) {
                  Provider.of<DbProvider>(context, listen: false)
                      .deleteFavorite(state.favorite[index].id);
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DetailPage.routeName,
                        arguments: state.favorite[index].id);
                  },
                  child: ListTile(
                    title: Text(favorite.name),
                    subtitle: Text(favorite.city),
                    trailing: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
