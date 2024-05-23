import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';
import 'package:restaurant_app_api/provider/restaurant_detail_provider.dart'
    as detail_provider;
import '../provider/db_provider.dart' as db_provider;
import '../widget/card_menus.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/detail_page';
  final String getImage = "https://restaurant-api.dicoding.dev/images/medium/";

  final String id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => detail_provider.RestaurantDetailProvider(
            apiDetail: ApiDetail(), id: id),
        child: _detailPage(),
      ),
    );
  }

  Consumer<detail_provider.RestaurantDetailProvider> _detailPage() {
    return Consumer<detail_provider.RestaurantDetailProvider>(
        builder: (context, state, _) {
      if (state.state == detail_provider.ResultState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.state == detail_provider.ResultState.hasData) {
        var restaurant = state.result;
        return SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBarDetail(context, restaurant),
              _buildBodyDetail(restaurant, context)
            ],
          ),
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

  SliverToBoxAdapter _buildBodyDetail(
      WelcomeDetail restaurant, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  restaurant.restaurant.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                _buildIconFavorite(restaurant)
              ],
            ),
            _sizedHeight(8.0),
            Row(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Text(
                      restaurant.restaurant.rating.toString(),
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                    Text(
                      restaurant.restaurant.address,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),
            _sizedHeight(16.0),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _sizedHeight(8.0),
            Text(
              restaurant.restaurant.description,
            ),
            _sizedHeight(16.0),
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _sizedHeight(8.0),
            buildCardMenus(restaurant.restaurant.categories, Axis.horizontal),
            _sizedHeight(16.0),
            Text(
              'Foods',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _sizedHeight(8.0),
            buildCardMenus(restaurant.restaurant.menus.foods, Axis.horizontal),
            _sizedHeight(16.0),
            Text(
              'Drinks',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _sizedHeight(8.0),
            buildCardMenus(restaurant.restaurant.menus.drinks, Axis.horizontal),
            _sizedHeight(16.0),
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _sizedHeight(8.0),
            buildCardReviews(context, restaurant),
            _sizedHeight(16.0)
          ],
        ),
      ),
    );
  }

  Consumer<db_provider.DbProvider> _buildIconFavorite(
      WelcomeDetail restaurant) {
    return Consumer<db_provider.DbProvider>(
      builder:
          (BuildContext context, db_provider.DbProvider value, Widget? child) {
        return FutureBuilder(
          future: Provider.of<db_provider.DbProvider>(context)
              .isFavorited(restaurant.restaurant.id),
          builder: (context, snapshot) {
            var isFavorited = snapshot.data ?? false;

            final favorite = RestaurantElement(
                id: restaurant.restaurant.id,
                name: restaurant.restaurant.name,
                description: restaurant.restaurant.description,
                pictureId: restaurant.restaurant.pictureId,
                city: restaurant.restaurant.city,
                rating: restaurant.restaurant.rating);

            return _buildIcon(isFavorited, context, restaurant, favorite);
          },
        );
      },
    );
  }

  Material _buildIcon(bool isFavorited, BuildContext context,
      WelcomeDetail restaurant, RestaurantElement favorite) {
    return Material(
        child: isFavorited
            ? IconButton(
                onPressed: () =>
                    Provider.of<db_provider.DbProvider>(context, listen: false)
                        .deleteFavorite(restaurant.restaurant.id),
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 30.0,
                ))
            : IconButton(
                onPressed: () =>
                    Provider.of<db_provider.DbProvider>(context, listen: false)
                        .addFavorite(favorite),
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.grey,
                  size: 30.0,
                )));
  }

  SliverAppBar _buildAppBarDetail(
      BuildContext context, WelcomeDetail restaurant) {
    return SliverAppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Color(0xFF1A4D2E),
            ),
            child: IconButton(
              color: const Color(0xFFF5EFE6),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            )),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          height: 32.0,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
          ),
          child: Container(
            width: 40.0,
            height: 5.0,
            decoration: BoxDecoration(
              color: const Color(0xFF1A4D2E),
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ),
      ),
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: restaurant.restaurant.pictureId,
          child: Image.network(
            "$getImage${restaurant.restaurant.pictureId}",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  SizedBox buildCardReviews(BuildContext context, WelcomeDetail restaurant) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: restaurant.restaurant.customerReviews.length,
          itemBuilder: (context, index) {
            var customer = restaurant.restaurant.customerReviews[index];
            return Column(
              children: [
                ListTile(
                  title: Text(
                    customer.name,
                    style: const TextStyle(
                        color: Color(0xFF1A4D2E), fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    customer.review,
                    style: const TextStyle(color: Color(0xFF1A4D2E)),
                  ),
                ),
                const Divider(
                  height: 20,
                )
              ],
            );
          },
        ));
  }

  SizedBox _sizedHeight(double height) {
    return SizedBox(
      height: height,
    );
  }
}
