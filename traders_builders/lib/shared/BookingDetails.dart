class BookingDetails {
  String bookingId;
  String traderName;
  String serviceName;
  String dateFrom;
  String dateTo;
  String addressLineOne;
  String addressLineTwo;
  String city;
  String postalCode;
  String bookingStatus;
  String creationDateTime;
  String bookingCode;
  String description;

  BookingDetails({
    required this.bookingId,
    required this.traderName,
    required this.serviceName,
    required this.dateFrom,
    required this.dateTo,
    required this.addressLineOne,
    required this.addressLineTwo,
    required this.city,
    required this.postalCode,
    required this.bookingStatus,
    required this.creationDateTime,
    required this.bookingCode,
    required this.description,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      bookingId: json['booking_id'],
      traderName: json['trader_name'],
      serviceName: json['service_name'],
      dateFrom: json['date_from'],
      dateTo: json['date_to'],
      addressLineOne: json['address_line_one'],
      addressLineTwo: json['address_line_two'],
      city: json['city'],
      postalCode: json['postal_code'],
      bookingStatus: json['booking_status'],
      creationDateTime: json['creationdatetime'],
      bookingCode: json['booking_code'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'booking_id': bookingId,
    'trader_name': traderName,
    'service_name': serviceName,
    'date_from': dateFrom,
    'date_to': dateTo,
    'address_line_one': addressLineOne,
    'address_line_two': addressLineTwo,
    'city': city,
    'postal_code': postalCode,
    'booking_status': bookingStatus,
    'creationdatetime': creationDateTime,
    'booking_code': bookingCode,
    'description': description,
  };
}

