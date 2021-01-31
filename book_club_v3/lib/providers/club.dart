import 'package:flutter/Material.dart';

import 'dart:convert';

class Club with ChangeNotifier {
  String id;
  String clubName;
  Map members;
  String adminId;
  Map bookList;
  String imageUrl;

  Club({
    this.id,
    this.clubName,
    this.adminId,
    this.members,
    this.imageUrl,
    this.bookList,
  });

  Club.fromJson(Map json) {
    this.id = json['id'];
    this.clubName = json['clubName'];
    this.members = json['members'];
    this.adminId = json['adminId'];
    this.bookList = json['bookList'];
    this.imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'clubName': this.clubName,
      'members': this.members,
      'adminId': this.adminId,
      'bookList': this.bookList,
      'imageUrl': this.imageUrl,
    };
  }
}
