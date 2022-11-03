import 'package:flutter/material.dart';


import '../widgets/search_tab.dart';

class SearchScreen extends StatelessWidget {
  static const title = "Search";

  final String query = '';

  const SearchScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearch(),
        // Expanded(child: _buildList(context)),
      ],
    );
  }

  Widget _buildSearch() {
    return SearchTab(
      text: query,
      hintText: 'Nama Restaurant',
      // onChanged: _SearchRestaurants,
    );
  }
}
