class PhoneDetailsModal {
  final String countryName;
  final String countryCode;
  final int phoneNumberLength;
  final String isoCode; // New field for ISO code

  PhoneDetailsModal({
    required this.countryName,
    required this.countryCode,
    required this.phoneNumberLength,
    required this.isoCode, // Added to constructor
  });

  // Factory method to create a PhoneDetailsModal instance from a JSON map
  factory PhoneDetailsModal.fromJson(Map<String, dynamic> json) {
    return PhoneDetailsModal(
      countryName: json['country_name'],
      countryCode: json['country_code'],
      phoneNumberLength: json['phone_number_length'],
      isoCode: json['iso_code'], // Added to factory method
    );
  }

  // Method to convert a PhoneDetailsModal instance back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'country_name': countryName,
      'country_code': countryCode,
      'phone_number_length': phoneNumberLength,
      'iso_code': isoCode, // Added to JSON conversion
    };
  }
}
