import 'package:rescuedemo/utils/constants.dart';

class PreferencesModel{
  final String leadingIcon;
  final String title;
  final String subTitle;

  PreferencesModel({required this.leadingIcon, required this.title, required this.subTitle});
}

List<PreferencesModel> preferencesList=[
  PreferencesModel(leadingIcon: doctorIcon, title: 'Dr Khan Thondu', subTitle: 'Doctor'),
  PreferencesModel(leadingIcon: hospitalIcon, title: 'Galilee Hospital', subTitle: 'Hospital'),
];