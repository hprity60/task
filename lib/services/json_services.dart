import 'dart:developer';

import '../model/android_version.dart';

class JsonServices {
  static List<AndroidVersion> parseJson(dynamic input) {
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

  static String? searchById(dynamic input, int searchId) {
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

  static void printVersions(List<AndroidVersion> versions) {
    for (var version in versions) {
      log('ID: ${version.id}, Title: ${version.title}');
    }
  }
}
