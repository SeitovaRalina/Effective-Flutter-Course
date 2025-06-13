class Location {
  final String address;
  final double lat;
  final double lng;

  const Location({
    this.address = '',
    required this.lat,
    required this.lng,
  });
}

class OmskLocation extends Location {
  const OmskLocation({
    super.lat = 54.9924,
    super.lng = 73.3686,
  });
}