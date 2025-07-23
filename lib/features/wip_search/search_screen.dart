import 'package:flutter/material.dart';
import 'package:jourscape/features/wip_search/search_field_active.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SafeArea(child: SearchFieldActive()),
          ),
        ],
      ),
    );
  }
}
