import 'favorite_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/restaurant_list_provider.dart';
// import '../data/api/api_service.dart';
// import '../data/models/restaurant_list.dart';
import '../utils/result_state.dart';
import '../widgets/restaurant_card_list.dart';


class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  // late Future<RestaurantList> _restaurantList;

  // @override
  // void initState() {
  //   super.initState();
  //   _restaurantList = ApiService().fetchList();
  // }

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantListProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return RestaurantCardList(restaurant: restaurant);
            },
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else if (state.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, FavoriteScreen.routeName);
            },
            icon: const Icon(
              Icons.favorite_border,
            ),
          ),
        ],
        title: Text(
          'Restaurant',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Recommendation restaurant for you!',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: _buildList(context),
            )
          ],
        ),
      ),
    );
  }
}
