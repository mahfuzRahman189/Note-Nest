import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  final Box<ProfileModel> _profileBox = Hive.box<ProfileModel>('profile');

  String get name => _profileBox.isNotEmpty
      ? _profileBox.getAt(0)!.name
      : "Md Mahfuzur Rahman";
  String get shortForm =>
      _profileBox.isNotEmpty ? _profileBox.getAt(0)!.shortForm : "MMR";
  String get email => _profileBox.isNotEmpty
      ? _profileBox.getAt(0)!.email
      : "ID : 0182220012101189";

  void updateProfile(String name, String shortForm, String email) {
    final profile =
        ProfileModel(name: name, shortForm: shortForm, email: email);
    if (_profileBox.isEmpty) {
      _profileBox.add(profile);
    } else {
      _profileBox.putAt(0, profile);
    }
    notifyListeners();
  }
}
