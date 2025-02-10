class Advertisements {
  final String id;
  final String admin_id;
  final String title;
  final String image;
  final String logo;
  final String description;

  const Advertisements({
    required this.id,
    required this.admin_id,
    required this.title,
    required this.image,
    required this.logo,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        admin_id,
        title,
        image,
        logo,
        description,
      ];
}
