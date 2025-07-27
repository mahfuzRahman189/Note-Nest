import 'package:hive/hive.dart';
part 'profile_model.g.dart';

@HiveType(typeId: 3)
class ProfileModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String shortForm;

  @HiveField(2)
  String email;

  ProfileModel(
      {required this.name, required this.shortForm, required this.email});
}
