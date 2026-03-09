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

  const Vehicle({
    required this.license,
    required this.vehicleModel,
    required this.voilation,
    required this.voilationText,
    required this.alertType,
  });
}
