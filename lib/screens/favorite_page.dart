import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/db_provider.dart';

import '../utils/result_state.dart';
import '../widgets/restaurant_card_list.dart';


class FavoriteScreen extends StatelessWidget {
  static const routeName = 'Favorite_screen';

  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: const Text(
                'Restaurant Favorite',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView.builder(
              itemCount: provider.favorite.length,
              itemBuilder: (context, index) {
                return RestaurantCardList(restaurant: provider.favorite[index]);
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: const Text(
                'Restaurant Favorite',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            body: Center(
              child: Material(
                child: Text(provider.message),
              ),
            ),
          );
        }
      },
    );
  }
}
