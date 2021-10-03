import 'package:flutter/material.dart';

class Searching extends StatelessWidget {
  const Searching({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search your Country"),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _ListItem(index-1);
          },
        itemCount: _notes.length+1,
      )
    );
  }
}
