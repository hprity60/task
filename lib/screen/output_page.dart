import 'package:flutter/material.dart';

import '../model/android_version.dart';

class OutputPage extends StatefulWidget {
  @override
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

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Android Versions'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  List<AndroidVersion> versions = parseJson(input1);
                  setState(() {
                    _versions = versions;
                  });
                  printVersions(versions);
                },
                child: Text('Output 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  List<AndroidVersion> versions = parseJson(input2);
                  setState(() {
                    _versions = versions;
                  });
                  printVersions(versions);
                },
                child: Text('Output 2'),
              ),
              ElevatedButton(
                onPressed: () {
                  int searchId = 2;
                  String? title = searchById(input1, searchId);
                  if (title != null) {
                    print('Title for ID $searchId: $title');
                  } else {
                    print('ID $searchId not found');
                  }
                },
                child: Text('Search By ID'),
              ),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  int searchId = int.tryParse(value) ?? 0;
                  String? title = searchById(input1, searchId);
                  if (title != null) {
                    print('Title for ID $searchId: $title');
                  } else {
                    print('ID $searchId not found');
                  }
                  setState(() {
                    _searchResults = _searchVersions(searchId);
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.isNotEmpty
                      ? _searchResults.length
                      : _versions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        'ID: ${(_searchResults.isNotEmpty ? _searchResults[index].id : _versions[index].id) ?? ''}, Title: ${(_searchResults.isNotEmpty ? _searchResults[index].title : _versions[index].title) ?? ''}',
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

  List<AndroidVersion> parseJson(dynamic input) {
    List<AndroidVersion> versions = [];

    if (input is List) {
      for (var item in input) {
        if (item is Map) {
          item.forEach((key, value) {
            var id = value['id'];
            var title = value['title'];
            if (id != null && title != null) {
              versions.add(AndroidVersion(id: id, title: title));
            }
          });
        } else if (item is List) {
          for (var subItem in item) {
            var id = subItem['id'];
            var title = subItem['title'];
            if (id != null && title != null) {
              versions.add(AndroidVersion(id: id, title: title));
            }
          }
        }
      }
    }

    return versions;
  }

  String? searchById(dynamic input, int searchId) {
    if (input is List) {
      for (var item in input) {
        if (item is Map) {
          for (var key in item.keys) {
            var id = item[key]['id'];
            var title = item[key]['title'];
            if (id == searchId) {
              return title;
            }
          }
        }
      }
    }

    return null;
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

  void printVersions(List<AndroidVersion> versions) {
    for (var version in versions) {
      print('ID: ${version.id}, Title: ${version.title}');
    }
  }
}
