import 'package:flutter/material.dart';

class SearchBarWidget {
  SearchBarWidget();

  Widget searchBar(
    TextEditingController _searchController,
    String hint,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
