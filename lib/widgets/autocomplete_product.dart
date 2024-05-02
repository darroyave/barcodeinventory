import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AutoCompleteProduct extends StatefulWidget {
  const AutoCompleteProduct({super.key});

  @override
  State<AutoCompleteProduct> createState() => _AutoCompleteProductState();
}

class _AutoCompleteProductState extends State<AutoCompleteProduct> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];

  void _fetchSuggestions(String query) async {
    final response = await http
        .get(Uri.parse('http://example.com/suggestions?query=$query'));
    if (response.statusCode == 200) {
      setState(() {
        _suggestions = List<String>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: _fetchSuggestions,
          decoration: const InputDecoration(
            labelText: 'Search',
            hintText: 'Type something...',
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_suggestions[index]),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
