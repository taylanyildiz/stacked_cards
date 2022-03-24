import 'package:flutter/material.dart';
import 'package:stacked_cards/widgets/src/list_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  /// Home screen titile.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: StackedListLayout(
        visualized: 10,
        initial: 10,
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 40.0),
        itemExtent: MediaQuery.of(context).size.height * .5,
        children: List.generate(30, (index) {
          return Container(
            color: Colors.accents[index % Colors.accents.length],
          );
        }),
      ),
    );
  }

  AppBar get _buildAppBar => AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
}
