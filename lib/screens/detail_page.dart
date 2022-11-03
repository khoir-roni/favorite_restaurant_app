import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/api/api_service.dart';
import '../data/models/restaurant_list.dart';
import '../provider/db_provider.dart';
import '../provider/restaurant_detail_provider.dart';
import '../theme/theme.dart';
import '../utils/result_state.dart';
import '../widgets/menu_list.dart';
import '../widgets/rating_star.dart';
import 'package:http/http.dart' show Client;

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail_page';

  final Restaurant restaurant;
  const DetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RestaurantDetailProvider>(
        create: (_) => RestaurantDetailProvider(
            apiService: ApiService(Client()), id: restaurant.id),
        child: Consumer<RestaurantDetailProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              ));
            } else if (state.state == ResultState.hasData) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  foregroundColor: Colors.black,
                  title: Text(
                    state.result.restaurant.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: Consumer<DatabaseProvider>(
                    builder: (context, dbValue, child) {
                  return FutureBuilder(
                      future: dbValue.isFavorited(restaurant.id),
                      builder: (context, favValue) {
                        var isFavorited = favValue.data ?? false;
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Hero(
                                    tag: state.result.restaurant.pictureId,
                                    child: Center(
                                      child: Image.network(
                                        "https://restaurant-api.dicoding.dev/images/small/${state.result.restaurant.pictureId}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: isFavorited
                                        ? IconButton(
                                            onPressed: () =>
                                                dbValue.removeFavorite(
                                                    state.result.restaurant.id),
                                            icon: const Icon(Icons.favorite),
                                            color: Colors.redAccent,
                                          )
                                        : IconButton(
                                            onPressed: () =>
                                                dbValue.addFavorite(restaurant),
                                            icon: const Icon(
                                                Icons.favorite_border),
                                            color: Colors.redAccent,
                                          ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildRatingStars(
                                        state.result.restaurant.rating),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      state.result.restaurant.name,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    const Divider(color: Colors.grey),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(state.result.restaurant.city),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                            'Rating: ${state.result.restaurant.rating}'),
                                      ],
                                    ),
                                    const Divider(color: Colors.grey),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Deskripsi',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      state.result.restaurant.description,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Menu",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "Food:",
                                ),
                              ),
                              MenuList(
                                  menu: state.result.restaurant.menus.foods),
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "Drink:",
                                ),
                              ),
                              MenuList(
                                  menu: state.result.restaurant.menus.drinks),

                              // MenuList(restaurantElement),
                            ],
                          ),
                        );
                      });
                }),
              );
            } else if (state.state == ResultState.noData) {
              return Center(
                child: Material(
                  child: Scaffold(
                    body: Center(
                      child: Text(state.message),
                    ),
                  ),
                ),
              );
            } else if (state.state == ResultState.error) {
              return Center(
                child: Material(
                  child: Scaffold(
                    body: Center(
                      child: Text(state.message),
                    ),
                  ),
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
        ),
      ),

      // FutureBuilder(
      //   future: _restaurantDetail,
      //   builder:
      //       (BuildContext context, AsyncSnapshot<RestaurantDetail> snapshot) {
      //     var state = snapshot.connectionState;
      //     if (state != ConnectionState.done) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else {
      //       if (snapshot.hasData) {
      //         var restaurantDetail = snapshot.data?.restaurant;
      //         return Scaffold(
      //           appBar: AppBar(
      //             title: Text(restaurantDetail!.name),
      //           ),
      //           body: SingleChildScrollView(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Hero(
      //                     tag: restaurantDetail.pictureId,
      //                     child: Center(
      //                       child: Image.network(
      //                         "https://restaurant-api.dicoding.dev/images/small/${restaurantDetail.pictureId}",
      //                         fit: BoxFit.cover,
      //                       ),
      //                     )),
      //                 Padding(
      //                   padding: const EdgeInsets.all(10),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       buildRatingStars(restaurantDetail.rating),
      //                       const SizedBox(
      //                         height: 5.0,
      //                       ),
      //                       Text(
      //                         restaurantDetail.name,
      //                         style: Theme.of(context).textTheme.headline5,
      //                       ),
      //                       const Divider(color: Colors.grey),
      //                       Row(
      //                         children: [
      //                           const Icon(
      //                             Icons.location_on_outlined,
      //                             color: Colors.black,
      //                           ),
      //                           const SizedBox(
      //                             width: 10.0,
      //                           ),
      //                           Text(restaurantDetail.city),
      //                         ],
      //                       ),
      //                       Row(
      //                         children: [
      //                           const Icon(Icons.star),
      //                           const SizedBox(
      //                             width: 10.0,
      //                           ),
      //                           Text('Rating: ${restaurantDetail.rating}'),
      //                         ],
      //                       ),
      //                       const Divider(color: Colors.grey),
      //                       const SizedBox(height: 10),
      //                       const Text(
      //                         'Deskripsi',
      //                         style: TextStyle(fontWeight: FontWeight.bold),
      //                       ),
      //                       const SizedBox(height: 10),
      //                       Text(
      //                         restaurantDetail.description,
      //                         style: Theme.of(context).textTheme.bodyText2,
      //                         maxLines: 4,
      //                         overflow: TextOverflow.ellipsis,
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 const Padding(
      //                   padding: EdgeInsets.all(8.0),
      //                   child: Text(
      //                     "Menu",
      //                     style: TextStyle(fontWeight: FontWeight.bold),
      //                   ),
      //                 ),
      //                 const Padding(
      //                   padding: EdgeInsets.only(left: 8),
      //                   child: Text(
      //                     "Food:",
      //                   ),
      //                 ),
      //                 MenuList(menu: restaurantDetail.menus.foods),
      //                 const Padding(
      //                   padding: EdgeInsets.only(left: 8),
      //                   child: Text(
      //                     "Drink:",
      //                   ),
      //                 ),
      //                 MenuList(menu: restaurantDetail.menus.drinks),

      //                 // MenuList(restaurantElement),
      //               ],
      //             ),
      //           ),
      //         );
      //       } else if (snapshot.hasError) {
      //         return Center(
      //           child: Material(
      //             child: Text(snapshot.error.toString()),
      //           ),
      //         );
      //       } else {
      //         return const Material(child: Text(''));
      //       }
      //     }
      //   },
      // ),
    );

    // lismenu(Menus menus) {}
  }

  // lismenu(Menus menus) {}
}
