import 'dart:convert';
import 'dart:io';

enum AlertType {
  okay,
  dueIn,
  overDue;

  @override
  String toString() {
    switch (this) {
      case AlertType.okay:
        return "Okay";
      case AlertType.dueIn:
        return "Due in";
      case AlertType.overDue:
        return "Overdue";
    }
  }
}

class Vehicle {
  final String license;
  final String vehicleModel;
  final String voilation;
  final String voilationText;
  final AlertType alertType;

  static List<FleetModel> _cachedVehicles = [];

  const Vehicle({
    required this.license,
    required this.vehicleModel,
    required this.voilation,
    required this.voilationText,
    required this.alertType,
  });

  static Future<List<FleetModel>> getVehicles() async {
    final uri = Uri.parse('http://192.168.31.2:5898/v1/vehicles');
    final client = HttpClient();

    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Request failed with status: ${response.statusCode}',
          uri: uri,
        );
      }

      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      final List<dynamic> rawList = decoded['response'] as List<dynamic>;

      final vehicles = rawList
          .map((e) => FleetModel.fromJson(e as Map<String, dynamic>))
          .toList();

      _cachedVehicles = vehicles;
      return vehicles;
    } finally {
      client.close();
    }
  }

  static List<FleetModel> get cachedVehicles =>
      List.unmodifiable(_cachedVehicles);

  static List<FleetModel> searchByLicense(String query) {
    final q = query.toLowerCase();
    return _cachedVehicles
        .where((v) => v.licensePlate?.toLowerCase().contains(q) ?? false)
        .toList();
  }

  static List<FleetModel> dueIn({int withinDays = 30}) {
    final now = DateTime.now();
    final threshold = now.add(Duration(days: withinDays));
    return _cachedVehicles.where((v) {
      return _documentDates(v).any((date) {
        if (date == null) return false;
        return date.isAfter(now) && date.isBefore(threshold);
      });
    }).toList();
  }

  static List<FleetModel> expired() {
    final now = DateTime.now();
    return _cachedVehicles.where((v) {
      return _documentDates(v).any((date) {
        if (date == null) return false;
        return date.isBefore(now);
      });
    }).toList();
  }

  static List<DateTime?> _documentDates(FleetModel v) => [
    parseDate(v.insuranceExpiry),
    parseDate(v.fitUpTo),
    parseDate(v.nationalPermitUpto),
    parseDate(v.puccUpto),
    parseDate(v.taxUpto),
    parseDate(v.permitValidUpto),
  ];

  static DateTime? parseDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      return DateTime.parse(raw.trim());
    } catch (_) {
      final parts = raw.trim().split('-');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      }
      return null;
    }
  }

  static void clearCache() => _cachedVehicles = [];
}

class FleetModel {
  String? licensePlate;
  String? ownerName;
  bool? isFinanced;
  String? financer;
  String? presentAddress;
  String? permanentAddress;
  String? insuranceCompany;
  String? insurancePolicy;
  String? insuranceExpiry;
  String? vehicleClass;
  String? registrationDate;
  String? puccUpto;
  String? puccNumber;
  String? chassisNumber;
  String? engineNumber;
  String? fuelType;
  String? brandName;
  String? brandModel;
  String? cubicCapacity;
  String? grossWeight;
  String? cylinders;
  String? color;
  String? norms;
  String? seatingCapacity;
  String? ownerCount;
  String? fitUpTo;
  String? taxUpto;
  String? permitValidUpto;
  String? nationalPermitNumber;
  String? nationalPermitUpto;
  String? nationalPermitIssuedBy;
  String? rcStatus;

  FleetModel({
    this.licensePlate,
    this.ownerName,
    this.isFinanced,
    this.financer,
    this.presentAddress,
    this.permanentAddress,
    this.insuranceCompany,
    this.insurancePolicy,
    this.insuranceExpiry,
    this.vehicleClass,
    this.registrationDate,
    this.puccUpto,
    this.puccNumber,
    this.chassisNumber,
    this.engineNumber,
    this.fuelType,
    this.brandName,
    this.brandModel,
    this.cubicCapacity,
    this.grossWeight,
    this.cylinders,
    this.color,
    this.norms,
    this.seatingCapacity,
    this.ownerCount,
    this.fitUpTo,
    this.taxUpto,
    this.permitValidUpto,
    this.nationalPermitNumber,
    this.nationalPermitUpto,
    this.nationalPermitIssuedBy,
    this.rcStatus,
  });

  FleetModel.fromJson(Map<String, dynamic> json) {
    licensePlate = json['license_plate'];
    ownerName = json['owner_name'];
    isFinanced = json['is_financed'];
    financer = json['financer'];
    presentAddress = json['present_address'];
    permanentAddress = json['permanent_address'];
    insuranceCompany = json['insurance_company'];
    insurancePolicy = json['insurance_policy'];
    insuranceExpiry = json['insurance_expiry'];
    vehicleClass = json['class'];
    registrationDate = json['registration_date'];
    puccUpto = json['pucc_upto'];
    puccNumber = json['pucc_number'];
    chassisNumber = json['chassis_number'];
    engineNumber = json['engine_number'];
    fuelType = json['fuel_type'];
    brandName = json['brand_name'];
    brandModel = json['brand_model'];
    cubicCapacity = json['cubic_capacity'];
    grossWeight = json['gross_weight'];
    cylinders = json['cylinders'];
    color = json['color'];
    norms = json['norms'];
    seatingCapacity = json['seating_capacity'];
    ownerCount = json['owner_count'];
    fitUpTo = json['fit_up_to'];
    taxUpto = json['tax_upto'];
    permitValidUpto = json['permit_valid_upto'];
    nationalPermitNumber = json['national_permit_number'];
    nationalPermitUpto = json['national_permit_upto'];
    nationalPermitIssuedBy = json['national_permit_issued_by'];
    rcStatus = json['rc_status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'license_plate': licensePlate,
      'owner_name': ownerName,
      'is_financed': isFinanced,
      'financer': financer,
      'present_address': presentAddress,
      'permanent_address': permanentAddress,
      'insurance_company': insuranceCompany,
      'insurance_policy': insurancePolicy,
      'insurance_expiry': insuranceExpiry,
      'class': vehicleClass,
      'registration_date': registrationDate,
      'pucc_upto': puccUpto,
      'pucc_number': puccNumber,
      'chassis_number': chassisNumber,
      'engine_number': engineNumber,
      'fuel_type': fuelType,
      'brand_name': brandName,
      'brand_model': brandModel,
      'cubic_capacity': cubicCapacity,
      'gross_weight': grossWeight,
      'cylinders': cylinders,
      'color': color,
      'norms': norms,
      'seating_capacity': seatingCapacity,
      'owner_count': ownerCount,
      'fit_up_to': fitUpTo,
      'tax_upto': taxUpto,
      'permit_valid_upto': permitValidUpto,
      'national_permit_number': nationalPermitNumber,
      'national_permit_upto': nationalPermitUpto,
      'national_permit_issued_by': nationalPermitIssuedBy,
      'rc_status': rcStatus,
    };
  }
}
