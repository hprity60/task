import 'dart:developer';

import 'package:flutter/material.dart';

import '../model/android_version.dart';
import 'widgets/custom_search_text_field.dart';
import 'package:task/services/json_services.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OutputPageState createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  final input1 = [
    {
      "0": {"id": 1, "title": "Gingerbread"},
      "1": {"id": 2, "title": "Jellybean"},
      "3": {"id": 3, "title": "KitKat"}
    },
    [
      {"id": 4, "title": "Lollipop"},
      {"id": 5, "title": "Pie"},
      {"id": 6, "title": "Oreo"},
      {"id": 7, "title": "Nougat"}
    ]
  ];

  final input2 = [
    {
      "0": {"id": 1, "title": "Gingerbread"},
      "1": {"id": 2, "title": "Jellybean"},
      "3": {"id": 3, "title": "KitKat"}
    },
    {
      "0": {"id": 8, "title": "Froyo"},
      "2": {"id": 9, "title": "Éclair"},
      "3": {"id": 10, "title": "Donut"}
    },
    [
      {"id": 4, "title": "Lollipop"},
      {"id": 5, "title": "Pie"},
      {"id": 6, "title": "Oreo"},
      {"id": 7, "title": "Nougat"}
    ]
  ];

  List<AndroidVersion> _versions = [];
  List<AndroidVersion> _searchResults = [];
  bool isInput1Active = true;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  List<AndroidVersion> versions =
                      JsonServices.parseJson(input1);
                  setState(() {
                    _versions = versions;
                    isInput1Active = true;
                  });
                  JsonServices.printVersions(versions);
                },
                child: const Text('Output 1'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  List<AndroidVersion> versions =
                      JsonServices.parseJson(input2);
                  setState(() {
                    _versions = versions;
                    isInput1Active = false;
                  });
                  JsonServices.printVersions(versions);
                },
                child: const Text('Output 2'),
              ),
              const SizedBox(height: 20),
              CustomSearchTextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    int searchId = int.tryParse(value) ?? 0;
                    String? title = JsonServices.searchById(input1, searchId);
                    if (title != null) {
                      log('Title for ID $searchId: $title');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('ID $searchId not found'),
                        ),
                      );
                      log('ID $searchId not found');
                    }

                    _searchResults = _searchVersions(searchId);
                  });
                },
              ),
              const SizedBox(height: 20),
              _versions.isNotEmpty
                  ? Text(
                      isInput1Active ? 'Output-1' : 'Output-2',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    )
                  : const Text(""),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: _searchResults.isNotEmpty
                      ? _searchResults.length
                      : _versions.length,
                  itemBuilder: (context, index) {
                    final version = _searchResults.isNotEmpty
                        ? _searchResults[index]
                        : _versions[index];
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          version == null ? Text('') : Text('${version.title}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<AndroidVersion> _searchVersions(int searchId) {
    List<AndroidVersion> searchResults = [];
    for (var version in _versions) {
      if (version.id == searchId) {
        searchResults.add(version);
      }
    }
    return searchResults;
  }
}
