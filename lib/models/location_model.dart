class Location {
  Location({
    required this.latitude,
    required this.longitude,
  });


  double latitude;
  double longitude;

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json["lat"],
    longitude: json["lng"],
  );
}
