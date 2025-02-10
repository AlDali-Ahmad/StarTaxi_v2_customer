import 'package:tawsella_final/Pages/advertisements/model/advertisements.dart';

class AdvertisementsModel extends Advertisements {
  const AdvertisementsModel({
    required super.id,
    required super.admin_id,
    required super.title,
    required super.image,
    required super.logo,
    required super.description,
  });

  factory AdvertisementsModel.fromJson(Map<String, dynamic> json) =>
      AdvertisementsModel(
        id: json['id'] ?? '',
        admin_id: json['admin_id'] ?? '',
        title: json['title'] ?? '',
        image: json['image'] ?? '',
        logo: json['logo'] ?? '',
        description: json['description'] ?? '',
      );
}
