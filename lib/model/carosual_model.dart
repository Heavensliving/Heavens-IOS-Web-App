class CarousalModel {
  final String id;
  final List<String> cafeImages;
  final List<String> homeScreenImages;

  CarousalModel({
    required this.id,
    required this.cafeImages,
    required this.homeScreenImages,
  });

  factory CarousalModel.fromJson(Map<String, dynamic> json) {
    return CarousalModel(
      id: json['_id'],
      cafeImages: List<String>.from(json['cafeImages']),
      homeScreenImages: List<String>.from(json['homeScreenImages']),
    );
  }

  static List<CarousalModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => CarousalModel.fromJson(item)).toList();
  }
}
