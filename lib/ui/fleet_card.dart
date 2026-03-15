import 'package:flutter/material.dart';

import '../models/vehicle.dart';

class FleetCard extends StatefulWidget {
  const FleetCard({
    super.key,
    required this.license,
    required this.vehicleModel,
    required this.voilation,
    required this.voilationText,
    required this.alertType,
    // Always required
    required this.registrationDate,
    required this.puccValidTill,
    required this.insuranceLastDate,
    required this.tax,
    // Optional
    this.permitDate,
    this.nationalPermitDate,
  });

  final String license;
  final String voilation;
  final String voilationText;
  final String vehicleModel;
  final AlertType alertType;

  // Always required fields
  final String registrationDate;
  final String puccValidTill;
  final String insuranceLastDate;
  final String tax;

  // Optional fields
  final String? permitDate;
  final String? nationalPermitDate;

  @override
  State<FleetCard> createState() => _FleetCardState();
}

class _FleetCardState extends State<FleetCard> {
  bool _isExpanded = false;

  /// Returns color based on alertType
  Color _alertColor({bool isLight = false}) {
    switch (widget.alertType) {
      case AlertType.okay:
        return isLight ? Colors.green.shade100 : Colors.green;
      case AlertType.dueIn:
        return isLight ? Colors.amber.shade100 : Colors.amber.shade400;
      case AlertType.overDue:
        return isLight ? Colors.red.shade100 : Colors.redAccent;
    }
  }

  /// Reusable date info row with icon
  Widget _dateRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: Stack(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // ── Top row: violation label + badge ──
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (widget.alertType == AlertType.okay)
                              ? "No Voilation"
                              : (widget.alertType == AlertType.dueIn)
                              ? "Expiring: ${widget.voilation}"
                              : "Voilation: ${widget.voilation}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: (widget.alertType == AlertType.okay)
                                ? Colors.green
                                : (widget.alertType == AlertType.dueIn)
                                ? Colors.amber[200]
                                : Colors.red[400],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.alertType.toString(),
                            style: TextStyle(
                              color: (widget.alertType == AlertType.okay)
                                  ? Colors.white
                                  : (widget.alertType == AlertType.dueIn)
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── License & model ──
                    Text(
                      widget.license,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.vehicleModel,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),

                    // ── Alert status row ──
                    Row(
                      children: [
                        (widget.alertType == AlertType.okay)
                            ? Container(
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            : (widget.alertType == AlertType.dueIn)
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber[400],
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.date_range_sharp,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.dangerous,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                        const SizedBox(width: 8),
                        Text(
                          widget.voilationText,
                          softWrap: true,
                          style: TextStyle(
                            color: (widget.alertType == AlertType.okay)
                                ? Colors.black
                                : (widget.alertType == AlertType.dueIn)
                                ? Colors.black
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 4),

                    // ── Collapsible section trigger ──
                    GestureDetector(
                      onTap: () => setState(() => _isExpanded = !_isExpanded),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Document Details',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Collapsible content ──
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _alertColor(isLight: true),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _dateRow(
                              Icons.app_registration_rounded,
                              'Registration',
                              widget.registrationDate,
                            ),
                            _dateRow(
                              Icons.eco_outlined,
                              'PUCC Valid Till',
                              widget.puccValidTill,
                            ),
                            _dateRow(
                              Icons.shield_outlined,
                              'Insurance Till',
                              widget.insuranceLastDate,
                            ),
                            _dateRow(
                              Icons.receipt_long_outlined,
                              'Tax',
                              widget.tax,
                            ),
                            // Optional: Permit
                            if (widget.permitDate != null)
                              _dateRow(
                                Icons.assignment_outlined,
                                'Permit',
                                widget.permitDate!,
                              ),
                            // Optional: National Permit
                            if (widget.nationalPermitDate != null)
                              _dateRow(
                                Icons.map_outlined,
                                'National Permit',
                                widget.nationalPermitDate!,
                              ),
                          ],
                        ),
                      ),
                      crossFadeState: _isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),

            // ── Left color indicator bar ──
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 12,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: _alertColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
